//
//  HomeChartCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import UIKit

class HomeChartCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var portfolioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        portfolioButton.cornerRadius = 28
        portfolioButton.setBackgroundImage(UIImage(color: .homeButtonHighlighted, size: CGSize(width: 1, height: 1)), for: .highlighted)
        portfolioButton.setBackgroundImage(UIImage(color: .homeButtonNormal, size: CGSize(width: 1, height: 1)), for: .normal)
    }
    
    func setupByModel(_ model: HomeChartItemModel) {
        titleLabel.text = model.title
        amountLabel.text = model.amount
        unitLabel.text = model.unit
    }
}
