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
            let dayModels = translateOriginToDayModel(content: content)
            return WeightModel(months: convertToMonthModels(models: dayModels))
        }
        return WeightModel()
    }
    
    private func translateOriginToDayModel(content: String) -> [WeightDayModel] {
        let dataArray = content.split(separator: "\n")
        let dayModels = dataArray
            .filter { $0.count == 40 }
            .map { row -> WeightDayModel in
                var model = WeightDayModel()
                model.date = String( row[row.index(row.startIndex, offsetBy: 2) ..< row.index(row.startIndex, offsetBy: 12)] )
                model.weight = String( row[row.index(row.startIndex, offsetBy: 19) ..< row.index(row.startIndex, offsetBy: 23)] ).cgFloat() ?? 0
                model.burpees = String( row[row.index(row.startIndex, offsetBy: 26) ..< row.index(row.startIndex, offsetBy:  28)] ).int ?? 0
                model.pushUps = String( row[row.index(row.startIndex, offsetBy: 31) ..< row.index(row.startIndex, offsetBy:  33)] ).int ?? 0
                model.fitBoxing = String( row[row.index(row.startIndex, offsetBy: 36) ..< row.index(row.startIndex, offsetBy:  38)] ).int ?? 0
                return model
            }
        return dayModels
    }
    
    private func convertToMonthModels(models: [WeightDayModel]) -> [WeightMonthModel] {
        var months = models.map { String($0.date[$0.date.startIndex ..< $0.date.index($0.date.startIndex, offsetBy: 7)]) }
        months.removeDuplicates()
        let monthModels = months.map { month -> WeightMonthModel in
            return WeightMonthModel(month: month, days: models.filter { $0.date.contains(month) })
        }
        return monthModels
    }
}
