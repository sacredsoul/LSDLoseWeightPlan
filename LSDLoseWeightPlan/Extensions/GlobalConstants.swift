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

struct NotificationName {
    static var showTabBar: Notification.Name { Notification.Name("showTabBar") }
    static var hideTabBar: Notification.Name { Notification.Name("hideTabBar") }
}

extension UIColor {
    static var backgroundColor: UIColor { UIColor(named: "backgroundColor") ?? #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.3215686275, alpha: 1) }
    
    static var gradientFrom: UIColor { #colorLiteral(red: 0.2235294118, green: 0.2470588235, blue: 0.3215686275, alpha: 1) }
    static var gradientTo: UIColor { #colorLiteral(red: 0.05882352941, green: 0.09411764706, blue: 0.1843137255, alpha: 1) }
    
    static var primaryTextColor: UIColor { #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1) }
    static var regularTextColor: UIColor { #colorLiteral(red: 0.3764705882, green: 0.3843137255, blue: 0.4, alpha: 1) }
    static var secondaryTextColor: UIColor { #colorLiteral(red: 0.6274509804, green: 0.6392156863, blue: 0.6666666667, alpha: 1) }
    static var placeholderColor: UIColor { #colorLiteral(red: 0.7529411765, green: 0.768627451, blue: 0.8, alpha: 1) }
    
}
