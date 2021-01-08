//
//  BaseNavigationController.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/10/26.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            NotificationCenter.default.post(name: NotificationName.hideTabBar, object: nil)
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count == 2 {
            NotificationCenter.default.post(name: NotificationName.showTabBar, object: nil)
        }
        return super.popViewController(animated: animated)
    }
}
