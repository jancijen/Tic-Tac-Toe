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

        // Play option
        let playButton = UIButton()
        playButton.backgroundColor = ThemeManager.menuButtonColor
        playButton.setTitleColor(.white, for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        playButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        // Settings option
        let settingsButton = UIButton()
        settingsButton.backgroundColor = ThemeManager.menuButtonColor
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
    private func playTapped() {
        let gameVC = GameViewController()
        self.navigationController?.pushViewController(GameViewController(), animated: <#T##Bool#>)
    }
}
