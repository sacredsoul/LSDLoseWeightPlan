//
//  HomePickUpCollectionCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/13.
//

import UIKit

class HomePickUpCollectionCell: RxCollectionViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setupSubviews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.cornerRadius = 8
    }

    func setupByModel(_ model: HomePickUpCollectionItemModel) {
        codeLabel.text = model.code
        nameLabel.text = model.name
        priceLabel.text = model.price
        percentLabel.text = model.percent + model.unit
        switch model.type {
        case .positive:
            percentLabel.textColor = UIColor.homePickUpPositiveColor
        case .negative:
            percentLabel.textColor = UIColor.homePickUpNegativeColor
        case .default:
            percentLabel.textColor = UIColor.primaryTextColor
        }
    }
}
