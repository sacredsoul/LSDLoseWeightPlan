//
//  CustomTabBar.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/3.
//

import UIKit

struct BarModel {
    var title: String
    var selectedImageName: String?
    var unselectedImageName: String?
}

class CustomTabBar: UIView {

    private var stackView: UIStackView!
    
    // MARK: - Properties
    var selectedCallback: ((Int) -> Void)?
    var selectedIndex: Int = -1 {
        willSet {
            if selectedIndex == newValue {
                return
            }
            select(index: newValue)
        }
    }
    var barModels = [BarModel]() {
        didSet {
            setupBarButtons()
        }
    }
    
    // MARK: - Private properties
    private var tabBarButtons = [UIButton]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = bounds
        stackView.frame.size = CGSize(width: bounds.width, height: 49)
    }
    
    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        self.stackView = stackView
    }
    
    private func setupBarButtons() {
        barModels.forEach { [weak self] in
            if let button = self?.setupButton(by: $0) {
                tabBarButtons.append(button)
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    private func setupButton(by model: BarModel) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.tertiaryLabel, for: .normal)
        button.setTitleColor(.label, for: .selected)
        button.setTitle(model.title, for: .normal)
        button.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        if let selectedImageName = model.selectedImageName {
            button.setImage(UIImage(named: selectedImageName), for: .selected)
        }
        if let unselectedImageName = model.unselectedImageName {
            button.setImage(UIImage(named: unselectedImageName), for: .normal)
        }
        return button
    }
    
    @objc private func selectAction(_ sender: UIButton) {
        selectedIndex = tabBarButtons.firstIndex(of: sender) ?? 0
    }
    
    private func select(index: Int) {
        for (i, button) in tabBarButtons.enumerated() {
            button.isSelected = i == index
        }
        selectedCallback?(index)
    }
}
