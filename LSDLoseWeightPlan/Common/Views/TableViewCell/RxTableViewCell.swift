//
//  RxTableViewCell.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/4.
//

import UIKit

class RxTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        setupBindings()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        setupSubviews()
        setupBindings()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupSubviews() {
        
    }
    
    func setupBindings() {
        
    }
}
