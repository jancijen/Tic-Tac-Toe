//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - GameViewController

/// Game view controller.
class GameViewController: UIViewController {
    // MARK: Private properties
    
    private let titleLabel: UILabel
    private let gameBoard: GameBoard
    private let model: Game
    
    // MARK: Initialization
    
    init(boardSize: Int, firstPlayer: Player, aiPlayer: Player) {
        gameBoard = GameBoard(boardSize: boardSize)
        titleLabel = UILabel()
        model = Game(boardSize: boardSize, firstPlayer: firstPlayer, aiPlayer: aiPlayer)
        
        super.init(nibName: nil, bundle: nil)
    
        // Delegates
        gameBoard.delegate = self
        model.delegate = self
        
        // Initial setup
        setupObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Deinitialization
    
    deinit {
        removeObservers()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view
        configure()
        
        // Let AI make a first move if it is on turn
        model.makeAIMoveIfShould()
    }
    
    // MARK: Private methods
    
    /**
     Configures view and its subviews.
     */
    private func configure() {
        // View configuration
        view.backgroundColor = .white
        
        // ---------------- Title ----------------
        // Hide title label on landscape
        titleLabel.isHidden = UIDevice.current.orientation == .landscapeLeft
                              || UIDevice.current.orientation == .landscapeRight
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.titleFontSize)
        titleLabel.text = "Game"
        
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
        
        // ---------------- Game board ----------------
        view.addSubview(gameBoard)
        gameBoard.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /**
     Sets observers.
     */
    private func setupObservers() {
        // GameState observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameStateChanged),
                                               name: Notification.Name(rawValue: "gameState"),
                                               object: nil)
    }
    
    /**
     Removes observers.
     */
    private func removeObservers() {
        // GameState observer
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "gameState"), object: nil)
    }
    
    /**
     Shows end game alert.
     
     - parameter title: Title to be shown in alert.
     - parameter image: Optional image to be shown in alert.
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

// MARK: - GameBoardDelegate

extension GameViewController: GameBoardDelegate {
    /**
     Selects tile at given position.
     
     - parameter gameBoard: Gameboard owning tile.
     - parameter position: Position of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func gameBoard(_ gameBoard: GameBoard, didSelectTileAt position: Position) -> Player? {
        return self.model.selectTile(at: position)
    }
}

// MARK: - GameDelegate

extension GameViewController: GameDelegate {
    /**
     Sets view of tile at given position.
     
     - parameter game: Game model.
     - parameter position: Position of tile to set mark on.
     - parameter mark: Mark to be set.
     */
    func game(_ game: Game, setTileViewAt position: Position, to mark: Player) {
        self.gameBoard.setMark(at: position, to: mark)
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

// MARK: - Buttons callbacks

extension GameViewController {
    /**
     Goes one step back in stack of view controllers. Method to be called after tapping on back button.
     */
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Notifications callbacks

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
        
        // Check for end state and set title and image accordingly
        switch newState {
        // WIN
        case .winX, .winO:
            // Multiplayer
            if model.aiPlayer == .undef {
                title = "WINNER IS"
                image = newState == .winX ? #imageLiteral(resourceName: "cross") : #imageLiteral(resourceName: "circle")
            }
            // Singleplayer
            else {
                title = newState == model.aiPlayer.win() ? "DEFEAT" : "VICTORY"
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
