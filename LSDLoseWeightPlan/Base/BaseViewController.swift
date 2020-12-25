//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/10/26.
//

import UIKit

/// Base view controller of all UIViewControllers
class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubviews()
        /// Adding bindings to main thread to avoid warning UITableViewAlertForLayoutOutsideViewHierarchy
        DispatchQueue.main.async {
            self.setupBindings()
        }
    }
    
    /// Override for setting up subviews
    func setupSubviews() {
        
    }
    
    /// Override for setting up bindings
    func setupBindings() {
        
    }
}
