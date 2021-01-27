//
//  MonthChartsViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/7.
//

import UIKit

class MonthChartsViewController: BaseViewController {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    var viewModel: ChartsViewModel!
    var headImage: UIImage?
    var toImageViewRect = CGRect(x: 0, y: -40, width: Constants.screenWidth, height: 600)
    var toMonthViewRect = CGRect(x: 0, y: 500, width: Constants.screenWidth, height: 80)
    
    // MARK: - Private properties
    private let topInset: CGFloat = 500
    private let bottomInset: CGFloat = 80
    private let maxPullDownDistance: CGFloat = 40
    private var lastOffsetY: CGFloat = -500
    private var dataSource: RxTableViewSectionedReloadDataSource<MonthChartSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headImageView.frame = toImageViewRect
        headImageView.image = headImage
    }
    
    override func setupSubviews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        tableView.register(nibWithCellClass: MonthDescriptionCell.self)
        tableView.register(nibWithCellClass: MonthWeightLineChartCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func setupBindings() {
        let dataSource = RxTableViewSectionedReloadDataSource<MonthChartSectionModel> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .summary(let item):
                let cell = tableView.dequeueReusableCell(withClass: MonthDescriptionCell.self, for: indexPath)
                cell.monthView.monthLabel.text = item.month
                cell.monthView.emojiLabel.text = item.emoji
                return cell
                
            case .lineChart(let item):
                let cell = tableView.dequeueReusableCell(withClass: MonthWeightLineChartCell.self, for: indexPath)
                cell.setupLineChartData(model: item)
                return cell
            }
        }
        self.dataSource = dataSource
        viewModel.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

extension MonthChartsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case .summary:
            return 80
        case .lineChart:
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let start = -topInset
        let end = start - maxPullDownDistance
        switch offsetY {
        case end ..< start:
            var bounds = headImageView.bounds
            bounds.size.height -= lastOffsetY - offsetY
            headImageView.bounds = bounds
            lastOffsetY = offsetY
        case -Constants.screenHeight ..< end:
            if scrollView.isDecelerating {
                return
            }
            toImageViewRect = headImageView.frame
            toMonthViewRect.origin.y = -end
            navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastOffsetY = -topInset
        self.headImageView.frame = self.toImageViewRect
    }
}
