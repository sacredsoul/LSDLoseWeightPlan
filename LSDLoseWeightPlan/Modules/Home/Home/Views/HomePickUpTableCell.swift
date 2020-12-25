//
//  HomePickUpTableCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/13.
//

import UIKit

class HomePickUpTableCell: RxTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottomLabel: UILabel!
    
    let viewModel = HomePickUpCollectionViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: Constants.screenWidth, height: 282)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.register(nibWithCellClass: HomePickUpCollectionSectionCell.self)
    }
    
    override func setupBindings() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomePickUpCollectionSectionModel> { (ds, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: HomePickUpCollectionSectionCell.self, for: indexPath)
            cell.setupByModel(item)
            return cell
        }
        viewModel.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.scrollToIndex
            .subscribe(onNext: { [weak self] index, animated in
                self?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
            }).disposed(by: disposeBag)
        
        viewModel.currentIndex
            .map { $0 - 1 }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        viewModel.originalDataSource
            .map { $0.first?.items.count ?? 0 }
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        pageControl.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                guard let `self` = self else { return (1, true) }
                return (self.pageControl.currentPage + 1, true)
            }
            .bind(to: viewModel.scrollToIndex)
            .disposed(by: disposeBag)
            
        collectionView.rx.didEndDecelerating
            .map { [weak self] _ in
                guard let `self` = self else { return 1 }
                let center = CGPoint(x: self.collectionView.contentOffset.x + self.collectionView.center.x, y: self.collectionView.center.y)
                return self.collectionView.indexPathForItem(at: center)?.item ?? 1
            }
            .bind(to: viewModel.currentIndex)
            .disposed(by: disposeBag)
        
        collectionView.rx.didEndDragging
            .map { _ in false }
            .bind(to: collectionView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        collectionView.rx.didEndDecelerating
            .map { _ in true }
            .bind(to: collectionView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
    }
    
    func setupByModel(_ model: HomePickUpItemModel) {
        bottomLabel.text = model.updateDate
        viewModel.originalDataSource.accept(model.items)
    }
}

extension HomePickUpTableCell: UICollectionViewDelegate {
    
}
