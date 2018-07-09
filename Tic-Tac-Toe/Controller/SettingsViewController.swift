//
//  SettingsViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - SettingsViewController

/// Pre-game settings view controller.
class SettingsViewController: UIViewController {
    // MARK: Private properties
    
    private static let horizontalOffset: CGFloat = 40
    
    private let symbolSwitch: UISwitch = UISwitch()
    private let turnSwitch: UISwitch = UISwitch()
    private let isSinglePlayer: Bool
    private let verticalOffset: CGFloat
    
    // MARK: Initialization
    
    init(isSinglePlayer: Bool) {
        self.isSinglePlayer = isSinglePlayer
        verticalOffset = isSinglePlayer ? 50 : 0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        // View configuration
        view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.titleFontSize)
        titleLabel.text = "Settings"
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // ---------------- Back button ----------------
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        // ---------------- Symbol choice ----------------
        // Switch
        symbolSwitch.onTintColor = .black
        
        view.addSubview(symbolSwitch)
        symbolSwitch.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-verticalOffset)
        }
        
        // Cross image
        let crossImageView = UIImageView(image: #imageLiteral(resourceName: "cross"))
        
        view.addSubview(crossImageView)
        crossImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.right.equalTo(symbolSwitch.snp.left).offset(-SettingsViewController.horizontalOffset)
            make.centerY.equalTo(symbolSwitch)
        }
        
        // Circle image
        let circleImageView = UIImageView(image: #imageLiteral(resourceName: "circle"))
        
        view.addSubview(circleImageView)
        circleImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.left.equalTo(symbolSwitch.snp.right).offset(SettingsViewController.horizontalOffset)
            make.centerY.equalTo(symbolSwitch)
        }
        
        if isSinglePlayer {
            // ---------------- First turn choice ----------------
            // Switch
            turnSwitch.onTintColor = .black
            view.addSubview(turnSwitch)
            turnSwitch.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.height.equalTo(20)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(verticalOffset)
            }
            
            // Player image
            let playerImageView = UIImageView(image: #imageLiteral(resourceName: "human"))
            
            view.addSubview(playerImageView)
            playerImageView.snp.makeConstraints { make in
                make.height.width.equalTo(64)
                make.right.equalTo(turnSwitch.snp.left).offset(-SettingsViewController.horizontalOffset)
                make.centerY.equalTo(turnSwitch)
            }
            
            // PC image
            let robotImageView = UIImageView(image: #imageLiteral(resourceName: "robot"))
            
            view.addSubview(robotImageView)
            robotImageView.snp.makeConstraints { make in
                make.height.width.equalTo(64)
                make.left.equalTo(turnSwitch.snp.right).offset(SettingsViewController.horizontalOffset)
                make.centerY.equalTo(turnSwitch)
            }
        }
        
        // ---------------- Play button ----------------
        let playButton = UIButton()
        playButton.backgroundColor = ThemeManager.menuButtonColor
        playButton.titleLabel?.font = ThemeManager.appFont(size: ThemeManager.buttonFontSize)
        playButton.setTitleColor(.white, for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}

// MARK: - Button callbacks

extension SettingsViewController {
    /**
     Displays game according to user's choices. Method to be called after play button has been tapped.
     */
    @objc private func playTapped() {
        // Get user's choices from switch(es)
        let playersSymbole = symbolSwitch.isOn ? Player.O : Player.X
        let firstTurn = turnSwitch.isOn ? playersSymbole.opposite() : playersSymbole
        
        // Create and show game
        if isSinglePlayer {
            let gameVC = GameViewController(boardSize: 3, firstPlayer: firstTurn, aiPlayer: playersSymbole.opposite())
            navigationController?.pushViewController(gameVC, animated: true)
        } else {
            let gameVC = GameViewController(boardSize: 3, firstPlayer: firstTurn, aiPlayer: .undef)
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
    
    /**
     Goes one step back in stack of view controllers. Method to be called after back button has been tapped.
     */
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
