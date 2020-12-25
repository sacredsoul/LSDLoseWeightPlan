//
//  HomeFoldCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/6.
//

import UIKit

class HomeFoldCell: RxTableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var foldButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.roundCorners([.topLeft, .topRight], radius: 10)
    }
    
}
