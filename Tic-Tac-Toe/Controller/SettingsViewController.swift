//
//  SettingsViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// View controller for pre-game settings.
class SettingsViewController: UIViewController {
    // MARK: - Private static attributes
    private static let horizontalOffset: CGFloat = 40  // TODO
    // MARK: - Private attributes
    private let isSinglePlayer: Bool
    private let verticalOffset: CGFloat // TODO
    private let symbolSwitch: UISwitch = UISwitch()
    private let turnSwitch: UISwitch = UISwitch()
    
    // MARK: - Public methods
    init(isSinglePlayer: Bool) {
        self.isSinglePlayer = isSinglePlayer
        self.verticalOffset = isSinglePlayer ? 50 : 0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
     }
    
    // MARK: - Private methods
    /**
     Configure view and its subviews.
     */
    private func configure() {
        // View configuration
        self.view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.titleFontSize)
        titleLabel.text = "Settings"
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // ---------------- Back button ----------------
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
        }
        
        // ---------------- Symbol choice ----------------
        // Switch
        symbolSwitch.onTintColor = .black
        
        self.view.addSubview(symbolSwitch)
        symbolSwitch.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-self.verticalOffset)
        }
        
        // Cross image
        let crossImageView = UIImageView(image: #imageLiteral(resourceName: "cross"))
        
        self.view.addSubview(crossImageView)
        crossImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.right.equalTo(symbolSwitch.snp.left).offset(-SettingsViewController.horizontalOffset)
            make.centerY.equalTo(symbolSwitch)
        }
        
        // Circle image
        let circleImageView = UIImageView(image: #imageLiteral(resourceName: "circle"))
        
        self.view.addSubview(circleImageView)
        circleImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.left.equalTo(symbolSwitch.snp.right).offset(SettingsViewController.horizontalOffset)
            make.centerY.equalTo(symbolSwitch)
        }
        
        if isSinglePlayer {
            // ---------------- First turn choice ----------------
            // Switch
            turnSwitch.onTintColor = .black
            self.view.addSubview(turnSwitch)
            turnSwitch.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.height.equalTo(20)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(self.verticalOffset)
            }
            
            // Player image
            let playerImageView = UIImageView(image: #imageLiteral(resourceName: "human"))
            
            self.view.addSubview(playerImageView)
            playerImageView.snp.makeConstraints { make in
                make.height.width.equalTo(64)
                make.right.equalTo(turnSwitch.snp.left).offset(-SettingsViewController.horizontalOffset)
                make.centerY.equalTo(turnSwitch)
            }
            
            // PC image
            let robotImageView = UIImageView(image: #imageLiteral(resourceName: "robot"))
            
            self.view.addSubview(robotImageView)
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
        
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}

// MENU: - Button callbacks
extension SettingsViewController {
    /**
     Callback to be called after play button has been tapped.
     */
    @objc private func playTapped() {
        let playersSymbole = self.symbolSwitch.isOn ? Player.O : Player.X
        let firstTurn = self.turnSwitch.isOn ? playersSymbole.opposite() : playersSymbole
        
        // Create and show game
        if self.isSinglePlayer {
            let gameVC = SinglePlayerViewController(boardSize: 3, firstTurn: firstTurn, aiPlayer: playersSymbole.opposite())
            self.navigationController?.pushViewController(gameVC, animated: true)
        } else {
            let gameVC = MultiPlayerViewController(boardSize: 3,
                                                   firstTurn: firstTurn)
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
    }
    
    /**
     Callback to be called after back button has been tapped.
     */
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
