//
//  MonthDescriptionCell.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/8.
//

import UIKit

class MonthDescriptionCell: UITableViewCell {

    @IBOutlet weak var monthView: MonthDescriptionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
