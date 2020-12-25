//
//  RxCollectionViewCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/13.
//

import UIKit

class RxCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        setupBindings()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        
    }
    
    func setupBindings() {
        
    }
}
