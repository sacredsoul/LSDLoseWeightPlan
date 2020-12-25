//
//  HomeCouponFooterCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/19.
//

import UIKit

class HomeCouponFooterCell: RxTableViewCell {

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var topInfoLabel: UILabel!
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        moreButton.layer.cornerRadius = 24
        moreButton.layer.masksToBounds = true
    }
    
    func setupByModel(_ model: HomeCouponFooterItemModel) {
        let attributedInfo = NSAttributedString(string: model.infoForButton, attributes: [.foregroundColor: UIColor.secondaryTextColor, .underlineStyle: NSUnderlineStyle.single.rawValue])
        infoButton.setAttributedTitle(attributedInfo, for: .normal)
        
        topInfoLabel.text = model.infoForTop
        bottomInfoLabel.text = model.infoForBottom
        detailLabel.text = model.infoForDetail
        detailButton.setTitle(model.linkString, for: .normal)
    }
}

