//
//  ChartsViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import UIKit
import Charts

class ChartsViewController: BaseViewController {

    var lineChartView: LineChartView!
    
    let viewModel = ChartsViewModel()
    
    private var xLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupSubviews() {
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
        
        view.addSubview(lineChartView)
        self.lineChartView = lineChartView
    }

    override func setupBindings() {
        viewModel.lineDataSource
            .subscribe(onNext: { [weak self] model in
                if let last = model.months.last {
                    self?.setupLineChartData(model: last)
                }
            }).disposed(by: disposeBag)
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
    }
}

extension ChartsViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard value >= 0 && value.int < xLabels.count else {
            return ""
        }
        return xLabels[value.int].date(withFormat: "yyyy-MM-dd")!.string(withFormat: "d")
    }
}
