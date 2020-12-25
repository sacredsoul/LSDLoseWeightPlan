//
//  HomeModel.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import Foundation

enum HomeItemType {
    case notice(item: HomeNoticeItemModel)              // お知らせ
    case search(item: HomeSearchItemModel)              // 検索
    case chart(item: HomeChartItemModel)                // チャット
    case fold(item: HomeFoldItemModel)                  //
    case info(item: HomeInfoItemModel)                  // 本日の注文、定期買付設定中、速報結果
    case focus(item: HomeFocusItemModel)                // 注目
    case pickUp(item: HomePickUpItemModel)              // Pick Up
    case coupon(item: HomeCouponItemModel)              // 優待
    case couponFooter(item: HomeCouponFooterItemModel)  // 優待
    
    var identity: String {
        switch self {
        case .notice(let item):
            return String(describing: item)
        case .search(let item):
            return String(describing: item)
        case .chart(let item):
            return String(describing: item)
        case .fold:
            return "fold"
        case .info(let item):
            return String(describing: item)
        case .focus(let item):
            return String(describing: item)
        case .pickUp(let item):
            return String(describing: item)
        case .coupon(let item):
            return String(describing: item)
        case .couponFooter(let item):
            return String(describing: item)
        }
    }
}

enum HomeHeaderType {
    case none
    case imageAndTitle(imageName: String, title: String)
}

enum HomeFooterType {
    case none
    case line
}

enum HomeSectionType {
    case notice
    case search
    case chart
    case info
    case pickUp
    case coupon
    
}

struct HomeSectionModel {
    var identity: HomeSectionType
    var items: [Item]
    var header: HomeHeaderType = .none
    var footer: HomeFooterType = .none
}

extension HomeSectionModel: AnimatableSectionModelType {
    typealias Item = HomeItemType
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

extension HomeItemType: IdentifiableType, Equatable {
    typealias Identity = String
    
    static func == (lhs: HomeItemType, rhs: HomeItemType) -> Bool {
        return lhs.identity == rhs.identity
    }
}

struct HomeNoticeItemModel: HandyJSON {
    var noticeId: String = ""
    var title: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomeSearchItemModel {
    var placeholder: String
}

struct HomeChartItemModel: HandyJSON {
    var title: String = ""
    var amount: String = ""
    var unit: String = ""
    var isFolded: Bool = false
    // and others
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomeFoldItemModel {
    var isFolded: Bool = false
}

struct HomeInfoItemModel: HandyJSON {
    var firstTitle: String = ""
    var firstValue: String = ""
    var secondTitle: String? = nil
    var secondValue: String? = nil
    var thirdTitle: String? = nil
    var thirdValue: String? = nil
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomeFocusItemModel {
    
}

struct HomePickUpItemModel: HandyJSON {
    var updateDate: String = ""
    var items: [HomePickUpCollectionSectionModel] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomePickUpCollectionSectionModel: HandyJSON {
    var items: [Item] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

extension HomePickUpCollectionSectionModel: SectionModelType {
    typealias Item = HomePickUpCollectionGroupModel
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

struct HomePickUpCollectionGroupModel: HandyJSON {
    var headerFirst: String = ""
    var headerSecond: String = ""
    var items: [Item] = []
    var index: Int = -1
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

extension HomePickUpCollectionGroupModel: SectionModelType {
    typealias Item = HomePickUpCollectionItemModel
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}

struct HomePickUpCollectionItemModel: HandyJSON {
    var code: String = ""
    var name: String = ""
    var price: String = ""
    var percent: String = ""
    var unit: String = ""
    var type: HomePickUpCollectionItemType = .default
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

enum HomePickUpCollectionItemType: Int, HandyJSONEnum {
    case `default` = 0
    case positive = 1
    case negative = -1
}

struct HomeCouponItemModel: HandyJSON {
    var code: String = ""
    var name: String = ""
    var description: String = ""
    var value: String = ""
    var unit: String = ""
    var imageUrl: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomeCouponFooterItemModel: HandyJSON {
    var infoForButton: String = ""
    var infoForTop: String = ""
    var infoForBottom: String = ""
    var infoForDetail: String = ""
    var linkString: String = ""
    var urlString: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}
