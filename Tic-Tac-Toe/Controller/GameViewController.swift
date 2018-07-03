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
    
    // MARK: - Public methods
    init(boardSize: Int, firstTurn: Player, playersSymbole: Player) {
        self.playersSymbole = playersSymbole
        self.currentTurn = firstTurn
        self.gameBoard = GameBoard(boardSize: boardSize)
        self.boardSize = boardSize
        
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
        if gameBoard.isWon() {
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
    }
}
