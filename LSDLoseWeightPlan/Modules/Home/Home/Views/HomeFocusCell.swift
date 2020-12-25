//
//  HomeFocusCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/6.
//

import UIKit

class HomeFocusCell: RxTableViewCell {

    @IBOutlet weak var focusImageView: UIImageView!
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
        detailButton.cornerRadius = 20
        detailButton.setBackgroundImage(UIImage(color: .homeButtonHighlighted, size: CGSize(width: 1, height: 1)), for: .highlighted)
        detailButton.setBackgroundImage(UIImage(color: .homeButtonNormal, size: CGSize(width: 1, height: 1)), for: .normal)
    }
}
