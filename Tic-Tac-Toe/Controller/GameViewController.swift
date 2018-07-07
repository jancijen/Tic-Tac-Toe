//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// Game view controller.
class GameViewController: UIViewController {
    // MARK: - Private attributes
    private let gameBoard: GameBoard
    private let titleLabel: UILabel
    private let model: Game
    
    // MARK: - Public methods
    init(boardSize: Int, firstPlayer: Player, aiPlayer: Player) {
        self.gameBoard = GameBoard(boardSize: boardSize)
        self.titleLabel = UILabel()
        self.model = Game(boardSize: boardSize, firstPlayer: firstPlayer, aiPlayer: aiPlayer)
        
        super.init(nibName: nil, bundle: nil)
    
        self.gameBoard.gameVCDelegate = self
        configure()
        setObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        self.model.makeAITurnIfShould()
    }
    
    // MARK: - Private methods
    private func configure() {
        // View configuration
        self.view.backgroundColor = .white
        
        // Title
        titleLabel.isHidden = UIDevice.current.orientation == .landscapeLeft
            || UIDevice.current.orientation == .landscapeRight
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.titleFontSize)
        titleLabel.text = "Game"
        
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
        
        // Show game board
        self.view.addSubview(self.gameBoard)
        self.gameBoard.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setObservers() {
        // Game state observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameStateChanged),
                                               name: Notification.Name(rawValue: "gameState"),
                                               object: nil)
    }
    
    private func removeObservers() {
        // Game state observer
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "gameState"), object: nil)
    }
    
    private func showEndGameAlert(title: String) {
        let alertView = AlertView(title: title, image: nil)
        
        alertView.addActionButton(title: "Replay") { [weak self] in
            self?.model.resetGame()
            self?.gameBoard.reset()
            alertView.dismiss(animated: true)
        }
        alertView.addActionButton(title: "Main Menu") { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
            alertView.dismiss(animated: true)
        }
        
        alertView.show(animated: true)
    }
}

// MARK: - GameViewControllerDelegate
extension GameViewController: GameViewControllerDelegate {
    func selectTile(row: Int, col: Int) -> Player? {
        return self.model.selectTile(row: row, col: col)
    }
}

// MARK: - Device orientation
extension GameViewController {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            self.titleLabel.isHidden = false
        case .landscapeLeft, .landscapeRight:
            self.titleLabel.isHidden = true
        default:
            break
        }
    }
}

// MARK: - Button callbacks
extension GameViewController {
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Notification callbacks
extension GameViewController {
    @objc private func gameStateChanged(notification: Notification) {
        // Get new state
        guard let userInfo = notification.userInfo,
              let newState = userInfo["newState"] as? GameState else {
                print("GameState notification error: Incorrect user info provided.")
                return
        }
        
        let title: String
        switch newState {
        case .winX, .winO:
            let aiPlayer = self.model.getAIPlayer()
            title = newState == aiPlayer.win() ? "DEFEAT" : "VICTORY"
        case .tie:
            title = "TIE"
        default:
            return
        }
        
        showEndGameAlert(title: title)
        return
    }
}
