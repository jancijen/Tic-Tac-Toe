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
        
        self.view.backgroundColor = .white
        
        // Title
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: 80) // TODO
        titleLabel.text = "Tic-Tac-Toe"
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let buttonFont = ThemeManager.appFont(size: 20)
        
        // Play option
        let playButton = UIButton()
        playButton.backgroundColor = ThemeManager.menuButtonColor
        playButton.titleLabel?.font = buttonFont
        playButton.setTitleColor(.white, for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        playButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        // Settings option
        let settingsButton = UIButton()
        settingsButton.backgroundColor = ThemeManager.menuButtonColor
        settingsButton.titleLabel?.font = buttonFont
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.setTitle("Settings", for: .normal)
        
        settingsButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        // Stack view (all menu options)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Button callbacks
extension MenuViewController {
    @objc private func playTapped() {
        let gameVC = GameViewController()
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
}
