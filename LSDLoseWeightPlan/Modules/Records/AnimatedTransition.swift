//
//  AnimatedTransition.swift
//  LSDLoseWeightPlan
//
//  Created by 揍腚腚 on 2021/1/10.
//

import UIKit

class AnimatedPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MonthRecordsViewController,
              let fromRect = fromVC.fromRect,
              let headImage = fromVC.headImage,
              let toVC = transitionContext.viewController(forKey: .to) as? MonthChartsViewController else {
            return
        }
        
        let imageView = UIImageView(frame: fromRect)
        imageView.image = headImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        let monthView = MonthDescriptionView(frame: fromVC.monthView.frame)
        monthView.frame.size.height = fromVC.monthView.frame.maxY - toVC.toMonthViewRect.minY
        
        let containerView = transitionContext.containerView
        containerView.addSubview(imageView)
        containerView.addSubview(monthView)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            imageView.frame = toVC.toImageViewRect
            monthView.frame.origin.y = toVC.toMonthViewRect.minY
        } completion: { (finished) in
            containerView.addSubview(toVC.view)
            imageView.removeFromSuperview()
            monthView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}

class AnimatedPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MonthChartsViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? MonthRecordsViewController,
              let toRect = toVC.fromRect else {
            return
        }
        
        let imageView = UIImageView(frame: fromVC.toImageViewRect)
        imageView.image = fromVC.headImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        let monthView = MonthDescriptionView(frame: fromVC.toMonthViewRect)
        monthView.frame.size.height = toVC.monthView.frame.maxY - fromVC.toMonthViewRect.minY
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        containerView.addSubview(monthView)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            imageView.frame = toRect
            monthView.frame.origin.y = toVC.monthView.frame.minY
        } completion: { (finished) in
            imageView.removeFromSuperview()
            monthView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}