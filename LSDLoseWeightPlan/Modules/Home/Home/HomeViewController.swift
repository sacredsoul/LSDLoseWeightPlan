//
//  HomeViewController.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import UIKit

/// ホーム画面
class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    private var dataSource: RxTableViewSectionedAnimatedDataSource<HomeSectionModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupSubviews() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "home_bg"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let imageView = UIImageView(frame: CGRect(x: 16, y: 0, width: 118, height: 26))
        imageView.image = UIImage(named: "home_logo")
        let barButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.setLeftBarButton(barButtonItem, animated: false)
    }
    
    func setupTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(nibWithCellClass: HomeNoticeCell.self)
        tableView.register(nibWithCellClass: HomeSearchCell.self)
        tableView.register(nibWithCellClass: HomeChartCell.self)
        tableView.register(nibWithCellClass: HomeFoldCell.self)
        tableView.register(nibWithCellClass: HomeInfoCell.self)
        tableView.register(nibWithCellClass: HomeFocusCell.self)
        tableView.register(nibWithCellClass: HomePickUpTableCell.self)
        tableView.register(nibWithCellClass: HomeCouponCell.self)
        tableView.register(nibWithCellClass: HomeCouponFooterCell.self)
    }
    
    override func setupBindings() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let viewModel = HomeViewModel()
        self.viewModel = viewModel
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<HomeSectionModel>(configureCell: { ds, tableView, indexPath, row -> UITableViewCell in
            switch row {
            case .notice(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeNoticeCell.self, for: indexPath)
                cell.setupByModel(item)
                return cell
                
            case .search(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeSearchCell.self, for: indexPath)
                cell.setupByModel(item)
                cell.searchButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.presentSearchViewController()
                    }).disposed(by: cell.disposeBag)
                return cell
                
            case .chart(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeChartCell.self, for: indexPath)
                cell.setupByModel(item)
                cell.portfolioButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.goToPortfolioViewController()
                    }).disposed(by: cell.disposeBag)
                return cell
                
            case .fold(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeFoldCell.self, for: indexPath)
                cell.foldButton.isSelected = item.isFolded
                cell.foldButton.rx.tap
                    .do(onNext: {
                        cell.foldButton.isSelected = !cell.foldButton.isSelected
                    })
                    .bind(to: viewModel.foldAction)
                    .disposed(by: cell.disposeBag)
                return cell
                
            case .info(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeInfoCell.self, for: indexPath)
                cell.setupByModel(item)
                return cell
                
            case .focus(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeFocusCell.self, for: indexPath)
                cell.detailButton.rx.tap
                    .subscribe(onNext: {
                        print(item)
                    }).disposed(by: cell.disposeBag)
                return cell
                
            case .pickUp(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomePickUpTableCell.self, for: indexPath)
                cell.setupByModel(item)
                return cell
                
            case .coupon(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeCouponCell.self, for: indexPath)
                cell.setupByModel(item)
                return cell
                
            case .couponFooter(let item):
                let cell = tableView.dequeueReusableCell(withClass: HomeCouponFooterCell.self, for: indexPath)
                cell.setupByModel(item)
                cell.moreButton.rx.tap
                    .subscribe(onNext: {
                        print(item)
                    }).disposed(by: cell.disposeBag)
                
                cell.infoButton.rx.tap
                    .subscribe(onNext: {
                        print(item.infoForButton)
                    }).disposed(by: cell.disposeBag)
                
                cell.detailButton.rx.tap
                    .subscribe(onNext: {
                        print(item.urlString)
                    }).disposed(by: cell.disposeBag)
                return cell
                
            }
        })
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade)
        self.dataSource = dataSource
        viewModel.dataSource.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HomeItemType.self)
            .subscribe(onNext: { type in
                
            }).disposed(by: disposeBag)
    }
    
    func presentSearchViewController() {
        print("search")
    }
    
    func goToPortfolioViewController() {
        print("portfolio")
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case .notice:
            return 48
        case .search:
            return 80
        case .chart(let item):
            return item.isFolded ? 25 : 437
        case .fold:
            return 36
        case .info(let item):
            let spacing: CGFloat = 32
            let lineHeight: CGFloat = 24
            var height: CGFloat = lineHeight
            if let _ = item.secondValue {
                height += lineHeight
            }
            if let _ = item.thirdValue {
                height += lineHeight
            }
            return height + spacing
        case .focus:
            return 290
        case .pickUp:
            return 362
        case .coupon:
            return 120
        case .couponFooter:
            return 235
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataSource[section].header {
        case .imageAndTitle(let imageName, let title):
            let header = HomeImageTitleHeaderView.loadFromNib()
            header.imageView.image = UIImage(named: imageName)
            header.titleLabel.text = title
            return header
        case .none:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource[section].header {
        case .imageAndTitle:
            return 60
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch dataSource[section].footer {
        case .line:
            let line = UIView()
            line.backgroundColor = UIColor.placeholderColor
            return line
        case .none:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch dataSource[section].footer {
        case .line:
            return 0.33
        case .none:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let last = tableView.indexPathForLastRow, tableView.indexPathsForVisibleRows?.contains(last) ?? false {
            tableView.backgroundColor = .white
        } else {
            tableView.backgroundColor = .clear
        }
    }
}
