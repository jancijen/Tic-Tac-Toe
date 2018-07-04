//
//  MenuViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

/// Menu screen view controller.
class MenuViewController: UIViewController {
    // MARK: Private attributes
    static let spacing: CGFloat = 32
    static let buttonWidth: CGFloat = 200
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    // MARK: - Private methods
    /**
     Configure view and its subviews.
     */
    private func configure() {
        // Configure view
        self.view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.bigTitleFontSize) // TODO
        titleLabel.text = "Tic-Tac-Toe"
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let buttonFont = ThemeManager.appFont(size: ThemeManager.buttonFontSize)
        // ---------------- Singleplayer option ----------------
        let singlePButton = UIButton()
        singlePButton.backgroundColor = ThemeManager.menuButtonColor
        singlePButton.titleLabel?.font = buttonFont
        singlePButton.setTitleColor(.white, for: .normal)
        singlePButton.setTitle("Singleplayer", for: .normal)
        singlePButton.addTarget(self, action: #selector(singlePTapped), for: .touchUpInside)
        
        singlePButton.snp.makeConstraints { make in
            make.width.equalTo(MenuViewController.buttonWidth)
        }
        
        // ---------------- Multiplayer option ----------------
        let multiPButton = UIButton()
        multiPButton.backgroundColor = ThemeManager.menuButtonColor
        multiPButton.titleLabel?.font = buttonFont
        multiPButton.setTitleColor(.white, for: .normal)
        multiPButton.setTitle("Multiplayer", for: .normal)
        multiPButton.addTarget(self, action: #selector(multiPTapped), for: .touchUpInside)
        
        multiPButton.snp.makeConstraints { make in
            make.width.equalTo(MenuViewController.buttonWidth)
        }
        
        // Stack view (all menu options)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = MenuViewController.spacing
        
        stackView.addArrangedSubview(singlePButton)
        stackView.addArrangedSubview(multiPButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Button callbacks
extension MenuViewController {
    /**
     Singleplayer button callback.
     */
    @objc private func singlePTapped() {
        self.navigationController?.pushViewController(SettingsViewController(isSinglePlayer: true), animated: true)
    }
    
    /**
     Multiplayer button callback.
     */
    @objc private func multiPTapped() {
        self.navigationController?.pushViewController(SettingsViewController(isSinglePlayer: false), animated: true)
    }
}
