//
//  MenuViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - MenuViewController

/// Menu screen view controller.
class MenuViewController: UIViewController {
    // MARK: Private properties
    
    private static let spacing: CGFloat = 32
    private static let buttonWidth: CGFloat = 200
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view
        configure()
    }
    
    // MARK: Private methods
    
    /**
     Configures view and its subviews.
     */
    private func configure() {
        // Configure view
        view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.bigTitleFontSize)
        titleLabel.text = "Tic-Tac-Toe"
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
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
        
        // ---------------- Menu view ----------------
        let menuView = UIView()
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.left.bottom.equalToSuperview()
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
        
        menuView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Button callbacks

extension MenuViewController {
    /**
     Displays pre-game settings for singleplayer game. Singleplayer button's callback.
     */
    @objc private func singlePTapped() {
        navigationController?.pushViewController(SettingsViewController(isSinglePlayer: true), animated: true)
    }
    
    /**
     Displays pre-game settings for multiplayer game. Multiplayer button's callback.
     */
    @objc private func multiPTapped() {
        navigationController?.pushViewController(SettingsViewController(isSinglePlayer: false), animated: true)
    }
}
