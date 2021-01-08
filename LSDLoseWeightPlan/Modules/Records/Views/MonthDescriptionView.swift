//
//  MonthDescriptionView.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/8.
//

import UIKit

@IBDesignable
class MonthDescriptionView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromXib()
    }
    
    func initFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MonthDescriptionView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view.frame = bounds
        self.addSubview(view)
    }
    
}
