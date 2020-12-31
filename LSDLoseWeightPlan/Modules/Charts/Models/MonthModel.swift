//
//  MonthModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/31.
//

import Foundation

enum MonthItemType {
    case image(item: MonthImageItem)
    case info
    case chart
    
}

struct MonthSectionModel {
    var items: [MonthItem]
}

extension MonthSectionModel: AnimatableSectionModelType {
    typealias Item = MonthItem
    typealias Identity = String
    var identity: Identity {
        return items.map { $0.title }.joined()
    }
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

struct MonthItem: IdentifiableType, Equatable {
    var image: UIImage
    var title: String
    var emoji: String? = nil
    var identity: String {
        return title
    }
    
    static func == (lhs: MonthItem, rhs: MonthItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

struct MonthImageItem {
    var imageData: Data? = nil
}

struct MonthInfoItem {
    var weight: CGFloat = 0
    var burpees: Int = 0
    var pushUps: Int = 0
    var fitBoxing: Int = 0
}
