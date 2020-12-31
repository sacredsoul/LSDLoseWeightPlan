//
//  ChartsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

class ChartsViewModel {
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
                    MonthItem(image: UIImage(color: UIColor.random, size: CGSize(width: 1, height: 1)), title: "2020年12月"),
                    MonthItem(image: UIImage(color: UIColor.random, size: CGSize(width: 1, height: 1)), title: "2020年11月"),
                    MonthItem(image: UIImage(color: UIColor.random, size: CGSize(width: 1, height: 1)), title: "2020年10月"),
                    MonthItem(image: UIImage(color: UIColor.random, size: CGSize(width: 1, height: 1)), title: "2020年09月"),
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
