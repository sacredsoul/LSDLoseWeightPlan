//
//  RecordsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

class RecordsViewModel {
    let collectionDataSource = PublishRelay<[MonthSectionModel]>()
    let lineDataSource = PublishRelay<WeightModel>()
    let reloadAction = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    init() {
//        reloadAction
//            .flatMapLatest {
//                ChartsService.getTargetData()
//                    .map { $0.translateToWeightModel() }
//            }
//            .bind(to: lineDataSource)
//            .disposed(by: disposeBag)
        
        reloadAction
            .flatMapLatest { _ -> Observable<[MonthSectionModel]> in
                let section = MonthSectionModel(items: [
                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年12月"),
                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年11月"),
                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年10月"),
                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年09月"),
                ])
                return Observable.just([section])
            }
            .bind(to: collectionDataSource)
            .disposed(by: disposeBag)
    }
}

class ChartsService {
    static func getTargetData() -> Observable<WeightResponseModel> {
        APIManager.shared.rx.request(.getTargetData)
            .map(to: WeightResponseModel.self)
            .asObservable()
    }
}
