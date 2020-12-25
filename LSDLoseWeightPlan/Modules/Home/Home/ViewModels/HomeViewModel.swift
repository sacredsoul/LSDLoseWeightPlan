//
//  HomeViewModel.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import Foundation

class HomeViewModel {
    let dataSource = BehaviorRelay<[HomeSectionModel]>(value: [])
    let foldAction = PublishRelay<Void>()
    private let isFolded = BehaviorRelay<Bool>(value: false)
    private var responseModel = PublishRelay<HomeResponseModel>()
    private let disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(responseModel, isFolded)
            .map { model, isFolded in
                var model = model
                model.chart.isFolded = isFolded
                return HomeViewModel.setupDataSource(by: model)
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        foldAction
            .withLatestFrom(isFolded)
            .map { !$0 }
            .bind(to: isFolded)
            .disposed(by: disposeBag)
        
    }
    
    static func setupDataSource(by model: HomeResponseModel) -> [HomeSectionModel] {
        var sections: [HomeSectionModel] = [
            HomeSectionModel(identity: .notice, items: [
                .notice(item: model.notice)
            ]),
            HomeSectionModel(identity: .search, items: [
                .search(item: HomeSearchItemModel(placeholder: "銘柄名•キーワードなどで探す"))
            ]),
            HomeSectionModel(identity: .chart, items: [
                .chart(item: model.chart)
            ]),
        ]
        
        /// info section
        var infoSection = HomeSectionModel(identity: .info, items: [], footer: .line)
        if let today = model.info.today {
            infoSection.items.append(.fold(item: HomeFoldItemModel(isFolded: model.chart.isFolded)))
            infoSection.items.append(.info(item: today))
        }
        if let regular = model.info.regular {
            infoSection.items.append(.info(item: regular))
        }
        if let result = model.info.result {
            infoSection.items.append(.info(item: result))
        }
        infoSection.items.append(.focus(item: HomeFocusItemModel()))
        sections.append(infoSection)
        
        /// pickUp section
        var pickUpSection = HomeSectionModel(identity: .pickUp, items: [], header: .imageAndTitle(imageName: "pickup", title: "Pick Up"), footer: .line)
        pickUpSection.items = [
            .pickUp(item: model.pickUp)
        ]
        sections.append(pickUpSection)
        
        /// 優待 section
        var couponSection = HomeSectionModel(identity: .coupon, items: [], header: .imageAndTitle(imageName: "yutai", title: model.couponHeader))
        couponSection.items = model.coupon.map {
            .coupon(item: $0)
        }
        
        /// 優待 footer
        couponSection.items.append(.couponFooter(item: model.couponFooter))
        sections.append(couponSection)
        
        return sections
    }
}

