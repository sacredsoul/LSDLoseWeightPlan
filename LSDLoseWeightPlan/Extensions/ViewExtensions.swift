//
//  ViewExtensions.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/10/26.
//

import Foundation
import UIKit

extension UIView {
    func setDefaultBackgroundColor() {
        setGradientBackgroundColor(from: .gradientFrom, to: .gradientTo)
    }
    
    func setGradientBackgroundColor(from: UIColor, to: UIColor) {
        let gradient = CAGradientLayer.init()
        
        gradient.colors = [from.cgColor, to.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor.init(patternImage: image!)
    }
}

extension UIStoryboard {
    static func instantiateViewController<T: UIViewController>(withClass name: T.Type, from storyboardName: String? = nil, bundle: Bundle? = nil) -> T? {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: name), bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}

protocol NibLoadable {
}
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibname ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
