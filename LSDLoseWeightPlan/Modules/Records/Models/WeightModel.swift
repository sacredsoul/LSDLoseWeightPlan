//
//  WeightModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

struct WeightModel {
    var target: String = ""
    var months: [WeightMonthModel] = []
}

extension WeightModel: SectionModelType {
    typealias Item = WeightMonthModel
    var items: [WeightMonthModel] {
        return months
    }
    
    init(original: Self, items: [Item]) {
        self = original
        self.months = items
    }
}

struct WeightMonthModel {
    var month: String = ""
    var emoji: String = ""
    var days: [WeightDayModel] = []
}

extension WeightMonthModel: SectionModelType {
    typealias Item = WeightDayModel
    var items: [WeightDayModel] {
        return days
    }
    
    init(original: Self, items: [Item]) {
        self = original
        self.days = items
    }
}

struct WeightDayModel {
    var date: String = ""
    var weight: CGFloat = 0
    var burpees: Int = 0
    var pushUps: Int = 0
    var fitBoxing: Int = 0
    var hiit: Int = 0
}
