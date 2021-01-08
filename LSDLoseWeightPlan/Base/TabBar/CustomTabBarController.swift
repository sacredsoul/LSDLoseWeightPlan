//
//  CustomTabBarController.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/3.
//

import UIKit

struct TabModel {
    var controller: UIViewController
    var title: String
    var selectedImageName: String?
    var unselectedImageName: String?
}

class CustomTabBarController: UIViewController {

    @IBOutlet weak var customTabBar: CustomTabBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tabBarBottomMarginConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var isHidden: Bool {
        customTabBar.isHidden
//        tabBarBottomMarginConstraint.constant == 0
    }
    
    var selectedIndex: Int {
        set {
            customTabBar.selectedIndex = newValue
        }
        get {
            customTabBar.selectedIndex
        }
    }
    var tabs = [TabModel]()
    
    /// Default init method
    static func initialize(tabs: [TabModel]) -> CustomTabBarController {
        let viewController = UIStoryboard.instantiateViewController(withClass: CustomTabBarController.self)!
        viewController.tabs = tabs
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        showDefaultController()
    }
    
    func setupTabBar() {
        bottomView.backgroundColor = UIColor.tertiarySystemGroupedBackground
        customTabBar.backgroundColor = bottomView.backgroundColor
        customTabBar.barModels = tabs.map { BarModel(title: $0.title, selectedImageName: $0.selectedImageName, unselectedImageName: $0.unselectedImageName) }
        customTabBar.selectedCallback = { [weak self] index in
            guard let `self` = self else { return }
            self.showChildController(at: index)
        }
    }
    
    func showDefaultController() {
        if !tabs.isEmpty {
            selectedIndex = 0
        }
    }
    
    func showChildController(at index: Int) {
        removeChildControllers()
        
        let vc = tabs[index].controller
        addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
    }
    
    func removeChildControllers() {
        children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    // MARK: - Hide tab bar
    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard hidden != isHidden else { return }
        customTabBar.isHidden = false
        view.layoutIfNeeded()
        if animated {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.customTabBar.alpha = hidden ? 0 : 1
            } completion: { [weak self] (finished) in
                self?.customTabBar.isHidden = hidden
            }
            return
        }
        customTabBar.isHidden = hidden
    }
}
