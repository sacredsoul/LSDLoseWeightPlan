//
//  RecordsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

class RecordsViewModel {
    let collectionDataSource = PublishRelay<[WeightModel]>()
    let lineDataSource = PublishRelay<WeightModel>()
    let reloadAction = PublishRelay<Void>()
    let saveImageUrlAction = PublishRelay<(String, String)>()
    let disposeBag = DisposeBag()
    
    init() {
        reloadAction
            .flatMapLatest {
                ChartsService.getTargetData()
                    .map { $0.translateToWeightModel() }
                    .map { [weak self] in
                        guard let `self` = self else { return [$0] }
                        return [self.mergeLocalData(to: $0)]
                    }
            }
            .bind(to: collectionDataSource)
            .disposed(by: disposeBag)
        
        saveImageUrlAction
            .subscribe(onNext: { [weak self] month, imagePath in
                let monthObject = MonthObject()
                monthObject.month = month
                monthObject.imagePath = imagePath
                RealmManager.shared.update(object: monthObject)
                self?.reloadAction.accept(())
            }).disposed(by: disposeBag)
        
//        reloadAction
//            .flatMapLatest { _ -> Observable<[MonthSectionModel]> in
//                let section = MonthSectionModel(items: [
//                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年12月"),
//                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年11月"),
//                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年10月"),
//                    MonthItem(imageUrl: "https://img.mp.itc.cn/upload/20161125/94f1c0cf2dde449abd701004b231daf0_th.jpeg", title: "2020年09月"),
//                ])
//                return Observable.just([section])
//            }
//            .bind(to: collectionDataSource)
//            .disposed(by: disposeBag)
    }
    
    private func mergeLocalData(to model: WeightModel) -> WeightModel {
        guard let localObjects = RealmManager.shared.query(type: MonthObject.self) else {
            return model
        }
        var months = model.months
        for (i, item) in model.months.enumerated() {
            months[i].imagePath = localObjects.filter { $0.month == item.month }.first?.imagePath
        }
        var model = model
        model.months = months
        return model
    }
}

class ChartsService {
    static func getTargetData() -> Observable<WeightResponseModel> {
        APIManager.shared.rx.request(.getTargetData)
            .map(to: WeightResponseModel.self)
            .asObservable()
    }
}
