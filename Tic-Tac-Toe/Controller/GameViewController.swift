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
    
        // Delegates
        self.gameBoard.gameVCDelegate = self
        self.model.gameVCDelegate = self
        
        configure()
        setupObservers()
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
    /**
     Configure view and its subviews.
     */
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
    
    /**
     Setup observers.
     */
    private func setupObservers() {
        // GameState observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameStateChanged),
                                               name: Notification.Name(rawValue: "gameState"),
                                               object: nil)
    }
    
    /**
     Remove observers.
     */
    private func removeObservers() {
        // GameState observer
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "gameState"), object: nil)
    }
    
    /**
     Show end game alert.
     
     - parameter title: Title to be shown in alert.
     - parameter image: Image to be shown in alert.
     */
    private func showEndGameAlert(title: String, image: UIImage?) {
        // Alert
        let alertView = AlertView(title: title, image: image)
        
        // Action: Replay
        alertView.addActionButton(title: "Replay") { [weak self, weak alertView] in
            // Reset view
            self?.gameBoard.reset()
            // Reset model
            self?.model.resetGame()
            // Dismiss alert
            alertView?.dismiss(animated: true)
        }
        // Action: Main Menu
        alertView.addActionButton(title: "Main Menu") { [weak self, weak alertView] in
            // Go to menu
            self?.navigationController?.popToRootViewController(animated: true)
            // Dismiss alert
            alertView?.dismiss(animated: true)
        }
        
        // Show alert
        alertView.show(animated: true)
    }
}

// MARK: - GameViewControllerDelegate
extension GameViewController: GameViewControllerDelegate {
    /**
     Select tile at given position.
     
     - parameter row: Row of tile.
     - parameter col: Column of tile.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func selectTile(row: Int, col: Int) -> Player? {
        return self.model.selectTile(row: row, col: col)
    }
}

// MARK: - GameDelegate
extension GameViewController: GameDelegate {
    func setTileView(row: Int, col: Int, value: Player) {
        gameBoard.setTileView(row: row, col: col, value: value)
    }
}

// MARK: - Device orientation
extension GameViewController {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            // Show game title in portrait mode
            self.titleLabel.isHidden = false
        case .landscapeLeft, .landscapeRight:
            // Hide game title in landscape mode
            self.titleLabel.isHidden = true
        default:
            break
        }
    }
}

// MARK: - Button callbacks
extension GameViewController {
    /**
     Callback to be called after tapping on back button.
     */
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Notification callbacks
extension GameViewController {
    /**
     Callback to be called after game state has been changed.
     */
    @objc private func gameStateChanged(notification: Notification) {
        // Get new state
        guard let userInfo = notification.userInfo,
              let newState = userInfo["newState"] as? GameState else {
                print("GameState notification error: Incorrect user info provided.")
                return
        }
        
        let title: String
        let image: UIImage?
        
        // Check for end state
        switch newState {
        // WIN
        case .winX, .winO:
            let aiPlayer = self.model.getAIPlayer()
            
            // Multiplayer
            if aiPlayer == .undef {
                title = "WINNER IS"
                image = newState == .winX ? #imageLiteral(resourceName: "cross") : #imageLiteral(resourceName: "circle")
            }
            // Singleplayer
            else {
                title = newState == aiPlayer.win() ? "DEFEAT" : "VICTORY"
                image = nil
            }
        // TIE
        case .tie:
            title = "TIE"
            image = nil
        default:
            // Game has not ended
            return
        }
        
        // Show end game alert
        showEndGameAlert(title: title, image: image)
        return
    }
}
