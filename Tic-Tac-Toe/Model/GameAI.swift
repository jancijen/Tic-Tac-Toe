//
//  GameAI.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

protocol GameBoardAIDelegate {
    func terminalState() -> GameState
    func getCurrentTurn() -> Player
}

/// GameAI class based on MiniMax algorithm.
class GameAI {
    // MARK: - Public attributes
    var gameBoardDelegate: GameBoardAIDelegate? = nil
    
    // MARK: - Private methods
    private func minimax(gameBoard: [[Player]], depth: Int, isMaximizer: Bool) -> Int {
        guard let gameBoardDelegate = self.gameBoardDelegate else {
            // TODO
            fatalError("Not able to compute AI move.")
        }
        
        // Check whether board is in terminal state
        let gameState = gameBoardDelegate.terminalState()
        let currentTurn = gameBoardDelegate.getCurrentTurn()
        switch gameState {
        case .winX:
            return currentTurn == .X ? 10 : -10
        case .winO:
            return currentTurn == .O ? 10 : -10
        case .tie:
            return 0
        default:
            break
        }
    }
}
