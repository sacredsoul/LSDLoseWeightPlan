//
//  HomeCouponCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/19.
//

import UIKit
import Kingfisher

class HomeCouponCell: RxTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 3
        containerView.layer.cornerRadius = 8
        
        adImageView.roundCorners([.topRight, .bottomRight], radius: 8)
    }
    
    func setupByModel(_ model: HomeCouponItemModel) {
        codeLabel.text = model.code
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        let attributedValue = NSAttributedString(string: model.value, attributes: [.foregroundColor: UIColor.homeHeaderTextColor, .font: UIFont.helveticaNeueMedium(ofSize: 16) ?? UIFont.systemFont(ofSize: 16)])
        let attributedUnit = NSAttributedString(string: model.unit, attributes: [.foregroundColor: UIColor.homeHeaderTextColor, .font: UIFont.helveticaNeue(ofSize: 13) ?? UIFont.systemFont(ofSize: 13)])
        valueLabel.attributedText = attributedValue + attributedUnit
        
        adImageView.kf.setImage(with: URL(string: model.imageUrl), placeholder: UIImage(named: "home_incentive_noImage"))
    }
}
