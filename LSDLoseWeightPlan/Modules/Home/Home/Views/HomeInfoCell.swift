//
//  HomeInfoCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/5.
//

import UIKit

class HomeInfoCell: RxTableViewCell {

    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstValueLabel: UILabel!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondValueLabel: UILabel!
    @IBOutlet weak var thirdContainerView: UIView!
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var thirdValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupByModel(_ model: HomeInfoItemModel) {
        firstTitleLabel.text = model.firstTitle
        firstValueLabel.text = model.firstValue
        secondTitleLabel.text = model.secondTitle
        secondValueLabel.text = model.secondValue
        thirdTitleLabel.text = model.thirdTitle
        thirdValueLabel.text = model.thirdValue
        secondContainerView.isHidden = model.secondValue == nil
        thirdContainerView.isHidden = model.thirdValue == nil
    }
}
