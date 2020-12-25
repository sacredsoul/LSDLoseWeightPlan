//
//  HomePickUpCollectionSetionCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/16.
//

import UIKit

class HomePickUpCollectionSectionCell: RxCollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setupSubviews() {
        let spacing: CGFloat = 8
        let inset: CGFloat = 15
        let width = floor((Constants.screenWidth - 2 * (spacing + inset)) / 3)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: width, height: 112)
        
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.register(nibWithCellClass: HomePickUpCollectionCell.self)
        
    }
    
    func setupByModel(_ model: HomePickUpCollectionGroupModel) {
        let firstPart = NSAttributedString(string: model.headerFirst, attributes: [.foregroundColor: UIColor.primaryTextColor])
        let secondPart = NSAttributedString(string: model.headerSecond, attributes: [.foregroundColor: UIColor.secondaryTextColor])
        titleLabel.attributedText = firstPart + secondPart
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomePickUpCollectionGroupModel> { (ds, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: HomePickUpCollectionCell.self, for: indexPath)
            cell.setupByModel(item)
            return cell
        }
        Observable.just([model])
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HomePickUpCollectionItemModel.self)
            .subscribe(onNext: { model in
                print(model)
            }).disposed(by: disposeBag)
    }
}
