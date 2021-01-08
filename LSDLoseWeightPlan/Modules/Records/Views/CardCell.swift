//
//  CardCell.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/31.
//

import UIKit

class CardCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
        setupShadow()
    }
    
    func setupSubviews() {
        clipsToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

    func setupShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.shadowOffset = CGSize(width: 5, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
    }
    
    func updateShadow(progress: CGFloat) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.shadowOpacity = Float(progress)
    }
}
