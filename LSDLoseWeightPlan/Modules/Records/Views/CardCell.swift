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
    
    private let waveHeight: CGFloat = 10
    private let waveRate: CGFloat = 0.01
    private let waveSpeed: CGFloat = 0.05
    private let risingSpeed: CGFloat = 3
    private let frontWaveColor = UIColor.white.withAlphaComponent(0.2)
    private let backWaveColor = UIColor.white.withAlphaComponent(0.1)
    private var offset: CGFloat = 0
    private var risingOffset: CGFloat = 0
    private var isFull = false
    
    private var displayLink: CADisplayLink?
    private var frontWaveLayer: CAShapeLayer?
    private var backWaveLayer: CAShapeLayer?
    
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
        contentView.addGestureRecognizer(longPress)
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }
    
    override func setupBindings() {
        if let longPress = contentView.gestureRecognizers?.first {
            longPress.rx.event
                .subscribe(onNext: { [weak self] recognizer in
                    guard let `self` = self else { return }
                    if recognizer.state == .began {
                        self.startLongPressAnimation()
                    }
                    if recognizer.state == .ended {
                        self.endLongPressAnimation()
                        if self.isFull {
                            self.longPressAction.accept(())
                        }
                    }
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
    
    private func startLongPressAnimation() {
        setupWave()
        startWave()
    }
    
    private func endLongPressAnimation() {
        endWave()
        resetWave()
    }
    
    private func setupWave() {
        let frontWaveLayer = CAShapeLayer()
        frontWaveLayer.frame = contentView.bounds
        frontWaveLayer.fillColor = frontWaveColor.cgColor
        self.frontWaveLayer = frontWaveLayer
        
        let backWaveLayer = CAShapeLayer()
        backWaveLayer.frame = contentView.bounds
        backWaveLayer.fillColor = backWaveColor.cgColor
        self.backWaveLayer = backWaveLayer
        
        imageView.layer.addSublayer(backWaveLayer)
        imageView.layer.addSublayer(frontWaveLayer)
    }
    
    private func resetWave() {
        resetOffset()
        removeWave()
    }
    
    private func resetOffset() {
        offset = 0
        risingOffset = 0
    }
    
    private func removeWave() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.2
        animation.fromValue = 1
        animation.toValue = 0
        animation.delegate = self
        frontWaveLayer?.add(animation, forKey: nil)
        backWaveLayer?.add(animation, forKey: nil)
    }
    
    private func startWave() {
        displayLink = CADisplayLink(target: self, selector: #selector(wave))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func endWave() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func wave() {
        isFull = risingOffset >= contentView.bounds.height
        offset += waveSpeed
        risingOffset += risingSpeed
        
        let startY = contentView.bounds.maxY
        
        let frontPath = UIBezierPath()
        frontPath.move(to: CGPoint(x: 0, y: startY))
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: 0, y: startY))
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        while x <= contentView.bounds.maxX {
            y = waveHeight * sin(x * waveRate + offset)
            
            let frontY = y + startY - risingOffset
            let backY = -y + startY - risingOffset
            
            frontPath.addLine(to: CGPoint(x: x, y: frontY))
            backPath.addLine(to: CGPoint(x: x, y: backY))
            
            x += 0.1
        }
        
        frontPath.addLine(to: CGPoint(x: contentView.bounds.maxX, y: startY))
        backPath.addLine(to: CGPoint(x: contentView.bounds.maxX, y: startY))
        
        backPath.close()
        backWaveLayer?.path = backPath.cgPath
        
        frontPath.close()
        frontWaveLayer?.path = frontPath.cgPath
    }
}

extension CardCell: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        frontWaveLayer?.removeFromSuperlayer()
        backWaveLayer?.removeFromSuperlayer()
    }
}
