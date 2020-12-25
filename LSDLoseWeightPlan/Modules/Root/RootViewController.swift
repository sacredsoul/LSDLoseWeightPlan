//
//  RootViewController.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/10/26.
//

import UIKit
import SwiftUI

/// Root of all other business controllers
class RootViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSplashViewController()
    }
    
    /// Add logic here to custom splashing controller
    func setupSplashViewController() {
        setupTabBarController()
    }
    
    func setupTabBarController() {
        let tabModels = [
            setupSubController(withClass: TargetViewController.self, title: "", selectedImageName: "GitHub", unselectedImageName: "GitHub-Light"),
            setupSubController(withClass: ChartsViewController.self, title: "", selectedImageName: "GitHub", unselectedImageName: "GitHub-Light"),
        ]
        
        let tabBarController = CustomTabBarController.initialize(tabs: tabModels)
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
    }
    
    // MARK: - Handlers
    private func setupSubController(withClass name: UIViewController.Type, title: String, selectedImageName: String? = nil, unselectedImageName: String? = nil) -> TabModel {
        let viewController = UIStoryboard.instantiateViewController(withClass: name)!
        let navigationController = BaseNavigationController(rootViewController: viewController)
        return TabModel(controller: navigationController, title: title, selectedImageName: selectedImageName, unselectedImageName: unselectedImageName)
    }
    
    private func setupSubController<T: View>(withHostingController controller: UIHostingController<T>, title: String, selectedImageName: String? = nil, unselectedImageName: String? = nil) -> TabModel {
        let navigationController = BaseNavigationController(rootViewController: controller)
        return TabModel(controller: navigationController, title: title, selectedImageName: selectedImageName, unselectedImageName: unselectedImageName)
    }
}
