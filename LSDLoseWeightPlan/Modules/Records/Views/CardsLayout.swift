//
//  CardsLayout.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/31.
//

import UIKit

protocol CardsLayoutDelegate: class {
    func transition(indexPath: IndexPath, progress: CGFloat)
    func transition(fromIndexPath: IndexPath, toIndexPath: IndexPath, progress: CGFloat)
}

class CardsLayout: UICollectionViewLayout {
    weak var delegate: CardsLayoutDelegate!
    
    override var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    var numberOfItems: Int {
        return collectionView.numberOfSections == 0 ? 0 : collectionView.numberOfItems(inSection: 0)
    }
    
    var visibleItemsCount: Int = 3
    
    var currentIndex: Int {
        return max(Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width), 0)
    }
    
    var minScale: CGFloat = 0.8
    var spacing: CGFloat = 36
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView.bounds.width * CGFloat(numberOfItems), height: collectionView.bounds.height)
    }
    
    var itemSize: CGSize {
        return collectionView.bounds.size * 0.7
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard numberOfItems > 0 else { return nil }
        
        let minVisibleIndex = currentIndex
        let maxVisibleIndex = min(numberOfItems - 1, currentIndex + visibleItemsCount)
        let attributes: [UICollectionViewLayoutAttributes] = (minVisibleIndex...maxVisibleIndex).map {
            let indexPath = IndexPath(item: $0, section: 0)
            return layoutAttributesForItem(at: indexPath, maxVisibleIndex: maxVisibleIndex)
        }
        return attributes
    }
    
    private func layoutAttributesForItem(at indexPath: IndexPath, maxVisibleIndex: Int) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        let visibleIndex = indexPath.item - currentIndex
        let topCardMidX = collectionView.contentOffset.x + itemSize.width / 2 + spacing
        let y = collectionView.bounds.midY - (collectionView.bounds.height - itemSize.height) / 4
        attributes.center = CGPoint(x: topCardMidX + spacing * CGFloat(visibleIndex), y: y)
        attributes.zIndex = numberOfItems - indexPath.item
        
        let offset = CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width))
        let offsetProgress = CGFloat(offset) / collectionView.bounds.width
        let scale = parallaxProgress(for: visibleIndex, offsetProgress, minScale)
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        var rate: CGFloat = 10
        if offsetProgress <= 0 || currentIndex == numberOfItems - 1 {
            rate = 1
        }
        if visibleIndex != 0 {
            rate = rate * 0.1
        }
        attributes.center.x -= spacing * offsetProgress * rate
        
        let progress = parallaxProgress(for: visibleIndex, offsetProgress)
        attributes.alpha = progress
        
        delegate?.transition(indexPath: indexPath, progress: progress)
        if visibleIndex == 0 && numberOfItems - 1 > currentIndex {
            let toIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
            delegate.transition(fromIndexPath: indexPath, toIndexPath: toIndexPath, progress: 1 - offsetProgress)
        }
        
        return attributes
    }
    
    private func parallaxProgress(for visibleIndex: Int, _ offsetProgress: CGFloat, _ minimum: CGFloat = 0) -> CGFloat {
        let step = (1.0 - minimum) / CGFloat(visibleItemsCount)
        return 1.0 - CGFloat(visibleIndex) * step + step * offsetProgress
    }
}
