//
//  CardCell.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/31.
//

import UIKit

class CardCell: RxCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var longPressAction = PublishRelay<Void>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateShadow(progress: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadow()
    }
    
    override func setupSubviews() {
        clipsToBounds = false
        
        let longPress = UILongPressGestureRecognizer()
        imageView.addGestureRecognizer(longPress)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }
    
    override func setupBindings() {
        if let longPress = imageView.gestureRecognizers?.first {
            longPress.rx.event
                .subscribe(onNext: { [weak self] recognizer in
                    self?.longPressAction.accept(())
                }).disposed(by: disposeBag)
        }
    }

    func setupShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.shadowOffset = CGSize(width: 5, height: 10)
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
    }
    
    func updateShadow(progress: CGFloat) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.shadowOpacity = Float(progress)
    }
}
