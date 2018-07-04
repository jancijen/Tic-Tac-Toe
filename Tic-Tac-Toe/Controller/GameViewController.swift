//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Private attributes
    private let playersSymbole: Player
    private var currentTurn: Player
    private let gameBoard: GameBoard
    private let boardSize: Int
    private let isSinglePlayerGame: Bool
    private let AI: GameAI // TODO
    
    // MARK: - Public methods
    init(boardSize: Int, firstTurn: Player, playersSymbole: Player, isSinglePlayer: Bool) {
        self.isSinglePlayerGame = isSinglePlayer
        self.playersSymbole = playersSymbole
        self.currentTurn = firstTurn
        self.gameBoard = GameBoard(boardSize: boardSize)
        self.boardSize = boardSize
        self.AI = GameAI(symboleAI: playersSymbole.opposite())
        
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
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: 60) // TODO
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
}

// MARK: - GameViewControllerDelegate
extension GameViewController: GameViewControllerDelegate {
    func getCurrentTurn() -> Player {
        return self.currentTurn
    }
    
    func nextTurn() {
        // Victory check
        if gameBoard.isWon() != .undef {
            let popUp = UIAlertController(title: "VICTORY", message: "...", preferredStyle: .alert)
            popUp.addAction(UIAlertAction(title: "OK", style: .default){ action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            self.present(popUp, animated: true, completion: nil)
            return
        }
        
        // Tie check
        if gameBoard.isFullyFilled() {
            let popUp = UIAlertController(title: "TIE", message: "...", preferredStyle: .alert)
            popUp.addAction(UIAlertAction(title: "OK", style: .default){ action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            self.present(popUp, animated: true, completion: nil)
            return
        }
        
        // Change turn
        self.currentTurn = self.currentTurn.opposite()
        
        // Let AI make a move, if it is on turn
        if isSinglePlayerGame && self.currentTurn == self.playersSymbole.opposite() {
            self.AI.makeBestMove(gameBoard: gameBoard)
        }
    }
}

// MARK: - Button callbacks
extension GameViewController {
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
