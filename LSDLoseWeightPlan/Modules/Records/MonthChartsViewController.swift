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
    private let maxPullDownDistance: CGFloat = 40
    private var lastOffsetY: CGFloat = -500
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headImageView.frame = toImageViewRect
        headImageView.image = headImage
    }
    
    override func setupSubviews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.register(nibWithCellClass: MonthDescriptionCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func setupBindings() {
        let dataSource = RxTableViewSectionedReloadDataSource<WeightMonthModel> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withClass: MonthDescriptionCell.self, for: indexPath)
            cell.monthView.monthLabel.text = dataSource[indexPath.section].month
            cell.monthView.emojiLabel.text = dataSource[indexPath.section].emoji
            return cell
        }
        viewModel.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

extension MonthChartsViewController: UITableViewDelegate {
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
