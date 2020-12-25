//
//  GlobalConstants.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/2.
//

import Foundation
import UIKit

struct Constants {
    static var screenWidth: CGFloat { UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { UIScreen.main.bounds.height }
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

extension UIColor {
    static var background: UIColor { #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.3215686275, alpha: 1) }
    
    static var gradientFrom: UIColor { #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.3215686275, alpha: 1) }
    static var gradientTo: UIColor { #colorLiteral(red: 0.05882352941, green: 0.09411764706, blue: 0.1843137255, alpha: 1) }
    
    static var primaryTextColor: UIColor { #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1) }
    static var regularTextColor: UIColor { #colorLiteral(red: 0.3764705882, green: 0.3843137255, blue: 0.4, alpha: 1) }
    static var secondaryTextColor: UIColor { #colorLiteral(red: 0.6274509804, green: 0.6392156863, blue: 0.6666666667, alpha: 1) }
    static var placeholderColor: UIColor { #colorLiteral(red: 0.7529411765, green: 0.768627451, blue: 0.8, alpha: 1) }
    
    static var infoCellNormal: UIColor { #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05) }
    static var infoCellHighlighted: UIColor { #colorLiteral(red: 0.0862745098, green: 0.1098039216, blue: 0.2039215686, alpha: 1) }
    
    static var homeButtonNormal: UIColor { #colorLiteral(red: 0.1137254902, green: 0.4078431373, blue: 0.7294117647, alpha: 1) }
    static var homeButtonHighlighted: UIColor { #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3042594178) }
    static var homeSectionBackground: UIColor { #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9843137255, alpha: 1) }
    static var homeHeaderTextColor: UIColor { #colorLiteral(red: 0.05882352941, green: 0.3176470588, blue: 0.6, alpha: 1) }
    static var homePickUpPositiveColor: UIColor { #colorLiteral(red: 0.9764705882, green: 0.4352941176, blue: 0.4039215686, alpha: 1) }
    static var homePickUpNegativeColor: UIColor { #colorLiteral(red: 0.3529411765, green: 0.6862745098, blue: 0.9058823529, alpha: 1) }
}

extension UIFont {
    static func helveticaNeue(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue", size: size)
    }
    
    static func helveticaNeueMedium(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Medium", size: size)
    }
    
    static func helveticaNeueBold(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Bold", size: size)
    }
}
