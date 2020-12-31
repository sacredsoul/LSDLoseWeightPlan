//
//  CardsLayout.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/31.
//

import UIKit

class CardsLayout: UICollectionViewLayout {
    
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
    var spacing: CGFloat = 35
    var didInitialSetup: Bool = false
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView.bounds.width * CGFloat(numberOfItems), height: collectionView.bounds.height)
    }
    
    var itemSize: CGSize {
        let width = collectionView.bounds.width * 0.7
        let height = width / 0.6
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        super.prepare()
        guard !didInitialSetup else { return }
        didInitialSetup = true
        collectionView.setContentOffset(CGPoint(x: collectionViewContentSize.width - collectionView.bounds.width, y: 0), animated: false)
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard numberOfItems > 0 else { return nil }
        
        let minVisibleIndex = max(currentIndex - visibleItemsCount + 1, 0)
        let maxVisibleIndex = max(min(numberOfItems - 1, currentIndex + 1), minVisibleIndex)
        let attributes: [UICollectionViewLayoutAttributes] = (minVisibleIndex...maxVisibleIndex).map {
            let indexPath = IndexPath(item: $0, section: 0)
            return layoutAttributesForItem(at: indexPath)
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        let visibleIndex = max(indexPath.item - currentIndex + visibleItemsCount, 0)
        let topCardMidX = collectionView.contentOffset.x + collectionView.bounds.width - itemSize.width / 2 - spacing / 2
        attributes.center = CGPoint(x: topCardMidX - spacing * CGFloat(visibleItemsCount - visibleIndex), y: collectionView.bounds.midY)
        attributes.zIndex = visibleIndex
        
        let offset = CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width))
        let offsetProgress = CGFloat(offset) / collectionView.bounds.width
        let scale = parallaxProgress(for: visibleIndex, offsetProgress, minScale)
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        switch visibleIndex {
        case visibleItemsCount + 1:
            attributes.center.x += collectionView.bounds.width - offset - spacing
        default:
            attributes.center.x -= spacing * offsetProgress
        }
        return attributes
    }
    
    private func parallaxProgress(for visibleIndex: Int, _ offsetProgress: CGFloat, _ minimum: CGFloat = 0) -> CGFloat {
        let step = (1.0 - minimum) / CGFloat(visibleItemsCount)
        return 1.0 - CGFloat(visibleItemsCount - visibleIndex) * step - step * offsetProgress
    }
}
