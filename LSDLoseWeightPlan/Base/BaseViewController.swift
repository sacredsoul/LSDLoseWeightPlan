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

        setupBaseConfig()
        setupSubviews()
        setupBindings()
    }
    
    private func setupBaseConfig() {
        view.backgroundColor = .backgroundColor
    }
    
    /// Override for setting up subviews
    func setupSubviews() {
        
    }
    
    /// Override for setting up bindings
    func setupBindings() {
        
    }
}
