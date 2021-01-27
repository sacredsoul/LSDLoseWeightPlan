//
//  ChartsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/11.
//

import Foundation

class ChartsViewModel {
    let dataSource = BehaviorRelay<[MonthChartSectionModel]>(value: [])
    
    init(dataSource: WeightMonthModel) {
        self.dataSource.accept(ChartsViewModel.setupDataSource(from: dataSource))
    }
    
    static func setupDataSource(from dataSource: WeightMonthModel) -> [MonthChartSectionModel] {
        let section = MonthChartSectionModel(items: [
            .summary(item: dataSource),
            .lineChart(item: dataSource)
        ])
        return [section]
    }
}
