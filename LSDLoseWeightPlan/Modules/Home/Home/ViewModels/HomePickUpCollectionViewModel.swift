//
//  HomePickUpCollectionViewModel.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/16.
//

import Foundation

class HomePickUpCollectionViewModel {
    let originalDataSource = PublishRelay<[HomePickUpCollectionSectionModel]>()
    let dataSource = PublishRelay<[HomePickUpCollectionSectionModel]>()
    let currentIndex = PublishRelay<Int>()
    let scrollToIndex = PublishRelay<(index: Int, animated: Bool)>()
    
    let disposeBag = DisposeBag()
    
    init() {
        currentIndex
            .withLatestFrom(Observable.combineLatest(currentIndex, dataSource))
            .filter { index, dataSource -> Bool in
                guard let section = dataSource.first else { return false }
                return index == 0 || index == section.items.count - 1
            }
            .map { index, dataSource in
                guard let section = dataSource.first else { return (1, false) }
                return index == 0 ? (section.items.count - 2, false) : (1, false)
            }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: scrollToIndex)
            .disposed(by: disposeBag)
        
        scrollToIndex
            .map { $0.0 }
            .bind(to: currentIndex)
            .disposed(by: disposeBag)
        
        dataSource
            .map { _ in (1, false) }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: scrollToIndex)
            .disposed(by: disposeBag)
        
        originalDataSource
            .filter { !$0.isEmpty }
            .map { HomePickUpCollectionViewModel.setupSections($0) }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
    }
    
    static func setupSections(_ sections: [HomePickUpCollectionSectionModel]) -> [HomePickUpCollectionSectionModel] {
        guard var newSection = sections.first else {
            return sections
        }
        let section = newSection
        newSection.items.insert(section.items.last!, at: 0)
        newSection.items.append(section.items.first!)
        return [newSection]
    }
}
