//
//  MonthWeightLineChartCell.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/27.
//

import UIKit
import Charts

class MonthWeightLineChartCell: RxTableViewCell {

    var lineChartView: LineChartView!
    
    private var xLabels: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineChartView.frame = contentView.bounds
    }
    
    override func setupSubviews() {
        setupLineChartView()
    }
    
    func setupLineChartView() {
        let lineChartView = LineChartView()
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
        contentView.addSubview(lineChartView)
    }
    
    func setupLineChartData(model: WeightMonthModel) {
        var dataEntries: [ChartDataEntry] = []
        for (i, item) in model.days.filter({ $0.weight > 0 }).enumerated() {
            let entry = ChartDataEntry(x: i.double, y: item.weight.double)
            dataEntries.append(entry)
            xLabels.append(item.date)
        }
        
        guard !dataEntries.isEmpty else { return }
        
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

extension MonthWeightLineChartCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard value >= 0 && value.int < xLabels.count else {
            return ""
        }
        return xLabels[value.int].date(withFormat: "yyyy-MM-dd")!.string(withFormat: "d")
    }
}
