//
//  MonthRecordsViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import UIKit
import Kingfisher
import Charts

class MonthRecordsViewController: BaseViewController {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthView: MonthDescriptionView!
    var lineChartView: LineChartView!
    
    let viewModel = RecordsViewModel()
    
    var fromRect: CGRect?
    var snapshotImage: UIImage?
    private var xLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.reloadAction.accept(())
    }
    
    override func setupSubviews() {
        let layout = collectionView.collectionViewLayout as! CardsLayout
        layout.delegate = self
        collectionView.register(nibWithCellClass: CardCell.self)
    }

    override func setupBindings() {
//        viewModel.lineDataSource
//            .subscribe(onNext: { [weak self] model in
//                if let last = model.months.last {
//                    self?.setupLineChartData(model: last)
//                }
//            }).disposed(by: disposeBag)
        
        let collectionDataSource = RxCollectionViewSectionedAnimatedDataSource<MonthSectionModel> { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: CardCell.self, for: indexPath)
            cell.imageView.kf.setImage(with: URL(string: item.imageUrl))
            return cell
        }
        
        viewModel.collectionDataSource
            .bind(to: collectionView.rx.items(dataSource: collectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                let offset = CGPoint(x: self.collectionView.bounds.width * CGFloat(indexPath.item), y: 0)
                if offset != self.collectionView.contentOffset {
                    self.collectionView.setContentOffset(offset, animated: true)
                    return
                }
                let cell = self.collectionView.cellForItem(at: indexPath)! as! CardCell
                self.fromRect = self.collectionView.convert(cell.frame, to: nil)
                self.snapshotImage = cell.imageView.image
                let viewController = UIStoryboard.instantiateViewController(withClass: MonthChartsViewController.self, from: "Records")!
                viewController.image = self.snapshotImage
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    func setupLineChartView() {
        let lineChartView = LineChartView(frame: CGRect(x: 0, y: 90, width: Constants.screenWidth, height: 300))
        lineChartView.dragEnabled = true
        lineChartView.pinchZoomEnabled = true
        lineChartView.legend.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.scaleYEnabled = false
        lineChartView.zoom(scaleX: 3, scaleY: 1, x: 0, y: 0)
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelCount = 8
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = self
        xAxis.forceLabelsEnabled = true
        xAxis.spaceMin = 1
        xAxis.spaceMax = 1
        xAxis.granularityEnabled = true
        xAxis.axisMaxLabels = 31
        xAxis.labelCount = 31
        
        self.lineChartView = lineChartView
    }

    func setupLineChartData(model: WeightMonthModel) {
        var dataEntries: [ChartDataEntry] = []
        for (i, item) in model.days.filter({ $0.weight > 0 }).enumerated() {
            let entry = ChartDataEntry(x: i.double, y: item.weight.double)
            dataEntries.append(entry)
            xLabels.append(item.date)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.drawFilledEnabled = true
        dataSet.mode = .cubicBezier
        dataSet.circleRadius = 4.0
        dataSet.lineWidth = 2.0
        dataSet.circleHoleRadius = 3.0
        dataSet.circleHoleColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)
        dataSet.setColor(UIColor(red: 0.114, green: 0.812, blue: 1, alpha: 1))
        
        let colors = [UIColor(hex: 0xC4F3FF)?.cgColor, UIColor(hex: 0x4083D6)?.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        dataSet.fill = Fill(linearGradient: gradient!, angle: 90)
        
        let lineChartData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineChartData
        lineChartView.chartDescription?.text = model.month
        if let last = dataEntries.last {
            lineChartView.moveViewToAnimated(xValue: last.x, yValue: last.y, axis: .left, duration: 2, easingOption: .easeInExpo)
        }
    }
}

extension MonthRecordsViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard value >= 0 && value.int < xLabels.count else {
            return ""
        }
        return xLabels[value.int].date(withFormat: "yyyy-MM-dd")!.string(withFormat: "d")
    }
}

extension MonthRecordsViewController: CardsLayoutDelegate {
    func transition(indexPath: IndexPath, progress: CGFloat) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCell
        cell?.updateShadow(progress: progress)
        print("indexPath: \(indexPath)-------progress: \(progress)")
    }
}

extension MonthRecordsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return PushTransition()
        }
        return nil
    }
}

class PushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MonthRecordsViewController,
              let fromRect = fromVC.fromRect,
              let image = fromVC.snapshotImage,
              let toVC = transitionContext.viewController(forKey: .to) as? MonthChartsViewController else {
            return
        }
        
        fromVC.monthView.isHidden = true
        
        let imageView = UIImageView(frame: fromRect)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        let monthView = MonthDescriptionView(frame: fromVC.monthView.frame)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        containerView.addSubview(monthView)
        
        toVC.view.alpha = 0
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            imageView.frame = toVC.originFrame
            monthView.frame = CGRect(x: 0, y: 500, width: Constants.screenWidth, height: 80)
        } completion: { (finished) in
            fromVC.monthView.isHidden = false
            toVC.view.alpha = 1
            imageView.removeFromSuperview()
            monthView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
