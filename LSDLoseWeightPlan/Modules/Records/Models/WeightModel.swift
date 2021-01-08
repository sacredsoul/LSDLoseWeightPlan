//
//  WeightModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

struct WeightModel {
    var months: [WeightMonthModel] = []
}

struct WeightMonthModel {
    var month: String = ""
    var days: [WeightDayModel] = []
}

struct WeightDayModel {
    var date: String = ""
    var weight: CGFloat = 0
    var burpees: Int = 0
    var pushUps: Int = 0
    var fitBoxing: Int = 0
}
