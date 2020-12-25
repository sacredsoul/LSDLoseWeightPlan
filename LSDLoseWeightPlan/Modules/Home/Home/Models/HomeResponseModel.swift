//
//  HomeResponseModel.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/12/4.
//

import Foundation
import HandyJSON

struct HomeResponseModel: HandyJSON {
    var notice: HomeNoticeItemModel = HomeNoticeItemModel(noticeId: "", title: "")
    var chart: HomeChartItemModel = HomeChartItemModel(title: "", amount: "", unit: "")
    var info: HomeResponseInfoModel = HomeResponseInfoModel()
    var pickUp: HomePickUpItemModel = HomePickUpItemModel(updateDate: "", items: [])
    var couponHeader: String = ""
    var coupon: [HomeCouponItemModel] = []
    var couponFooter = HomeCouponFooterItemModel(infoForButton: "", infoForTop: "", infoForBottom: "", infoForDetail: "", linkString: "", urlString: "")
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

struct HomeResponseInfoModel: HandyJSON {
    var today: HomeInfoItemModel?
    var regular: HomeInfoItemModel?
    var result: HomeInfoItemModel?
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}
