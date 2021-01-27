//
//  WeightResponseModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

struct WeightResponseModel: HandyJSON {
    var name: String = ""
    var path: String = ""
    var sha: String = ""
    var size: Int = 0
    var url: String = ""
    var htmlUrl: String = ""
    var gitUrl: String = ""
    var downloadUrl: String = ""
    var file: String = ""
    var content: String = ""
    var encoding: String = ""
    
    func translateToWeightModel() -> WeightModel {
        if let data = Data(base64Encoded: self.content, options: .ignoreUnknownCharacters), let content = String(data: data, encoding: .utf8) {
            let target = translateOriginToTarget(content: content)
            return WeightModel(target: target, months: translateOriginToMonthModels(content: content))
        }
        return WeightModel()
    }
    
    private func translateOriginToTarget(content: String) -> String {
        let dataArray = content.split(separator: "\n")
        let row = dataArray.filter { $0.contains("目標") }.first?.replacingOccurrences(of: "*", with: "").replacingOccurrences(of: "`", with: "")
        return String(row?.dropFirst(3) ?? "")
    }
    
    private func translateOriginToMonthModels(content: String) -> [WeightMonthModel] {
        let dataArray = content.split(separator: "\n")
        let dayModels = dataArray
            .filter { $0.count == 40 }
            .map { row -> WeightDayModel in
                var model = WeightDayModel()
                model.date = String( row[row.index(row.startIndex, offsetBy: 2) ..< row.index(row.startIndex, offsetBy: 12)] )
                model.weight = String( row[row.index(row.startIndex, offsetBy: 19) ..< row.index(row.startIndex, offsetBy: 23)] ).cgFloat() ?? 0
                model.burpees = String( row[row.index(row.startIndex, offsetBy: 26) ..< row.index(row.startIndex, offsetBy:  28)] ).int ?? 0
                model.pushUps = String( row[row.index(row.startIndex, offsetBy: 31) ..< row.index(row.startIndex, offsetBy:  33)] ).int ?? 0
                model.fullBody = String( row[row.index(row.startIndex, offsetBy: 36) ..< row.index(row.startIndex, offsetBy:  38)] ).int ?? 0
                return model
            }
        let monthModels = dataArray
            .filter { $0.count == 15 }
            .map { row -> WeightMonthModel in
                var model = WeightMonthModel()
                model.month = String(row[row.index(row.startIndex, offsetBy: 5) ..< row.index(row.startIndex, offsetBy: 13)])
                model.emoji = String(row[row.index(row.startIndex, offsetBy: 14) ..< row.index(row.startIndex, offsetBy: 15)])
                model.days = dayModels.filter { $0.date.contains(model.month.replacingOccurrences(of: "年", with: "-").replacingOccurrences(of: "月", with: "")) }
                return model
            }
        return monthModels
    }
    
    private func convertToMonthModels(month: String, models: [WeightDayModel]) -> [WeightMonthModel] {
        var months = models.map { String($0.date[$0.date.startIndex ..< $0.date.index($0.date.startIndex, offsetBy: 7)]) }
        months.removeDuplicates()
        let monthModels = months.map { month -> WeightMonthModel in
            return WeightMonthModel(month: month, days: models.filter { $0.date.contains(month) })
        }
        return monthModels
    }
}
