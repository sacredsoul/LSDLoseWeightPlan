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
    
    private var upperLabel: UILabel?
    private var lowerLabel: UILabel?
    private var leftLabel: UILabel?
    private var rightLabel: UILabel?
    private var animator: UIViewPropertyAnimator?
    
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
    
    // MARK: - Animation
    func transition(month: String, nextMonth: String, emoji: String, nextEmoji: String, progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else {
            return
        }
        
        monthLabel.text = month
        emojiLabel.text = emoji
        monthLabel.alpha = 0
        emojiLabel.alpha = 0
        upperLabel?.removeFromSuperview()
        lowerLabel?.removeFromSuperview()
        leftLabel?.removeFromSuperview()
        rightLabel?.removeFromSuperview()
        
        let upperLabel = copyLabel(monthLabel)
        upperLabel.text = month
        self.upperLabel = upperLabel
        addSubview(upperLabel)
        
        let lowerLabel = copyLabel(monthLabel)
        lowerLabel.text = nextMonth
        self.lowerLabel = lowerLabel
        addSubview(lowerLabel)
        
        let leftLabel = copyLabel(emojiLabel)
        leftLabel.text = emoji
        self.leftLabel = leftLabel
        addSubview(leftLabel)
        
        let rightLabel = copyLabel(emojiLabel)
        rightLabel.text = nextEmoji
        self.rightLabel = rightLabel
        addSubview(rightLabel)
        
        upperLabel.center = CGPoint(x: monthLabel.center.x, y: monthLabel.center.y - 20)
        upperLabel.alpha = 0
        lowerLabel.alpha = 1
        
        leftLabel.center = CGPoint(x: emojiLabel.center.x - 30, y: emojiLabel.center.y)
        leftLabel.alpha = 0
        rightLabel.alpha = 1
        leftLabel.transform = emojiLabel.transform.scaledBy(x: 0.5, y: 0.5)
        rightLabel.transform = emojiLabel.transform
        
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            guard let `self` = self else { return }
            upperLabel.center = self.monthLabel.center
            lowerLabel.center = CGPoint(x: self.monthLabel.center.x, y: self.monthLabel.center.y + 20)
            upperLabel.alpha = 1
            lowerLabel.alpha = 0
            
            leftLabel.center = self.emojiLabel.center
            rightLabel.center = CGPoint(x: self.emojiLabel.center.x + 30, y: self.emojiLabel.center.y)
            leftLabel.alpha = 1
            rightLabel.alpha = 0
            leftLabel.transform = self.emojiLabel.transform
            rightLabel.transform = self.emojiLabel.transform.scaledBy(x: 0.5, y: 0.5)
        }
        animator?.fractionComplete = progress
    }
    
    // MARK: - Handler
    private func copyLabel(_ orginLabel: UILabel) -> UILabel {
        let label = UILabel(frame: orginLabel.frame)
        label.font = orginLabel.font
        return label
    }
}
