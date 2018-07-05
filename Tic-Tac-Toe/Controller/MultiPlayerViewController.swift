//
//  MultiPlayerViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// Multi player game view controller.
class MultiPlayerViewController: UIViewController {
    // MARK: - Private attributes
    private var currentTurn: Player
    private let firstTurn: Player
    private let gameBoard: GameBoard
    private let boardSize: Int
    private let titleLabel: UILabel
    
    // MARK: - Public methods
    init(boardSize: Int, firstTurn: Player) {
        self.currentTurn = firstTurn
        self.firstTurn = firstTurn
        self.gameBoard = GameBoard(boardSize: boardSize)
        self.boardSize = boardSize
        self.titleLabel = UILabel()
        
        super.init(nibName: nil, bundle: nil)
        self.gameBoard.gameVCDelagate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
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
    
    private func showEndGameAlert(title: String, image: UIImage?) {
        let alertView = AlertView(title: title, image: image)
        
        alertView.addActionButton(title: "Replay") {
            self.resetGame()
            alertView.dismiss(animated: true)
        }
        alertView.addActionButton(title: "Main Menu") {
            self.navigationController?.popToRootViewController(animated: true)
            alertView.dismiss(animated: true)
        }
        
        alertView.show(animated: true)
    }
    
    private func resetGame() {
        gameBoard.reset()
        self.currentTurn = firstTurn
    }
}

// MARK: - GameViewControllerDelegate
extension MultiPlayerViewController: GameViewControllerDelegate {
    func getCurrentTurn() -> Player {
        return self.currentTurn
    }
    
    func nextTurn() {
        // Victory check
        let winner = gameBoard.isWon()
        if  winner != .undef {
            let winnerImage = winner == .X ? #imageLiteral(resourceName: "cross") : #imageLiteral(resourceName: "circle")
            showEndGameAlert(title: "Winner is", image: winnerImage)
            return
        }
        
        // Tie check
        if gameBoard.isFullyFilled() {
            showEndGameAlert(title: "Tie", image: nil)
            return
        }
        
        // Change turn
        self.currentTurn = self.currentTurn.opposite()
    }
}

// MARK: - Device orientation
extension MultiPlayerViewController {
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
extension MultiPlayerViewController {
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
