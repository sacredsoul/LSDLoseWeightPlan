//
//  HomeNoticeCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import UIKit

class HomeNoticeCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupByModel(_ model: HomeNoticeItemModel) {
        titleLabel.text = model.title
    }
}
