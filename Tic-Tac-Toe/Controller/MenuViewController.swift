//
//  MenuViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    // MARK: - Private methods
    private func configure() {
        // Configure view
        self.view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: 80) // TODO
        titleLabel.text = "Tic-Tac-Toe"
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let buttonFont = ThemeManager.appFont(size: 30)
        
        // ---------------- Singleplayer option ----------------
        let singlePButton = UIButton()
        singlePButton.backgroundColor = ThemeManager.menuButtonColor
        singlePButton.titleLabel?.font = buttonFont
        singlePButton.setTitleColor(.white, for: .normal)
        singlePButton.setTitle("Singleplayer", for: .normal)
        singlePButton.addTarget(self, action: #selector(singlePTapped), for: .touchUpInside)
        
        singlePButton.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        // ---------------- Multiplayer option ----------------
        let multiPButton = UIButton()
        multiPButton.backgroundColor = ThemeManager.menuButtonColor
        multiPButton.titleLabel?.font = buttonFont
        multiPButton.setTitleColor(.white, for: .normal)
        multiPButton.setTitle("Multiplayer", for: .normal)
        multiPButton.addTarget(self, action: #selector(multiPTapped), for: .touchUpInside)
        
        multiPButton.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        // Stack view (all menu options)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        
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
    @objc private func singlePTapped() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func multiPTapped() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
