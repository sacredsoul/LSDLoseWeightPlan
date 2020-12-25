//
//  ChartsViewModel.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import Foundation

class ChartsViewModel {
    let lineDataSource = BehaviorRelay<WeightModel>(value: WeightModel())
    let disposeBag = DisposeBag()
    
    init() {
        ChartsService.getTargetData()
            .map { $0.translateToWeightModel() }
            .bind(to: lineDataSource)
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
