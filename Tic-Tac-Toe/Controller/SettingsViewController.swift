//
//  SettingsViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Private attributes
    let symbolSwitch: UISwitch = UISwitch()
    let turnSwitch: UISwitch = UISwitch()
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
     }
    
    // MARK: - Private methods
    private func configure() {
        // View configuration
        self.view.backgroundColor = .white
        
        // ---------------- Title ----------------
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: 60) // TODO
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
            make.centerY.equalToSuperview().offset(-100)
        }
        
        // Cross image
        let crossImageView = UIImageView(image: #imageLiteral(resourceName: "cross"))
        
        self.view.addSubview(crossImageView)
        crossImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.right.equalTo(symbolSwitch.snp.left).offset(-40)
            make.centerY.equalTo(symbolSwitch)
        }
        
        // Circle image
        let circleImageView = UIImageView(image: #imageLiteral(resourceName: "circle"))
        
        self.view.addSubview(circleImageView)
        circleImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.left.equalTo(symbolSwitch.snp.right).offset(40)
            make.centerY.equalTo(symbolSwitch)
        }
        
        // ---------------- First turn choice ----------------
        // Switch
        turnSwitch.onTintColor = .black
        self.view.addSubview(turnSwitch)
        turnSwitch.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
        
        // Player image
        let playerImageView = UIImageView(image: #imageLiteral(resourceName: "human"))
        
        self.view.addSubview(playerImageView)
        playerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.right.equalTo(turnSwitch.snp.left).offset(-40)
            make.centerY.equalTo(turnSwitch)
        }
        
        // PC image
        let robotImageView = UIImageView(image: #imageLiteral(resourceName: "robot"))
        
        self.view.addSubview(robotImageView)
        robotImageView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.left.equalTo(turnSwitch.snp.right).offset(40)
            make.centerY.equalTo(turnSwitch)
        }
        
        // ---------------- Play button ----------------
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        playButton.backgroundColor = ThemeManager.menuButtonColor
        playButton.titleLabel?.font = ThemeManager.appFont(size: 30)
        playButton.setTitleColor(.white, for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
        }
    }
}

// MENU: - Button callbacks
extension SettingsViewController {
    @objc private func playTapped() {
        let playersSymbole = self.symbolSwitch.isOn ? Player.O : Player.X
        let firstTurn = self.turnSwitch.isOn ? playersSymbole.opposite() : playersSymbole
        
        // Create and show game VC
        self.navigationController?.pushViewController(GameViewController(boardSize: 3,
                                                                         firstTurn: firstTurn,
                                                                         playersSymbole: playersSymbole,
                                                                         isSinglePlayer: true), // todo
                                                      animated: true)
    }
    
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
