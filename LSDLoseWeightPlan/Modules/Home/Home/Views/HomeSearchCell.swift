//
//  HomeSearchCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import UIKit

class HomeSearchCell: RxTableViewCell {

    @IBOutlet weak var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        searchButton.cornerRadius = 10
    }
    
    func setupByModel(_ model: HomeSearchItemModel) {
        searchButton.setTitle(model.placeholder, for: .normal)
    }
}
