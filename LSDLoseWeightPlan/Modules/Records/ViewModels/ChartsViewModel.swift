//
//  ChartsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/11.
//

import Foundation

class ChartsViewModel {
    let dataSource = BehaviorRelay<[WeightMonthModel]>(value: [])
    
    init(dataSource: WeightMonthModel) {
        self.dataSource.accept([dataSource])
    }
}
