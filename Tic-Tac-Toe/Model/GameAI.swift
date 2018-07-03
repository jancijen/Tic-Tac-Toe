//
//  GameAI.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

/// GameAI class based on MiniMax algorithm.
class GameAI {
    // MARK: - Private attributes
    private let symboleAI: Player
    
    // MARK: - Public methods
    init(symboleAI: Player) {
        self.symboleAI = symboleAI
    }
    
    func makeBestMove(gameBoard: GameBoard) {
        let boardSize = gameBoard.getBoardSize()
        
        var bestMove = Int.min
        var bestMoveRow = -1
        var bestMoveCol = -1
        
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                // Check whether tile is empty
                if gameBoard.getTile(row: i, col: j).getTileState() == .undef {
                    // Make move
                    gameBoard.setTile(row: i, col: j, value: self.symboleAI)
                    
                    // Recursively call minimax
                    let tmpMove = minimax(gameBoard: gameBoard, depth: 0, isMaximizer: false)
                    
                    // Undo move
                    gameBoard.setTile(row: i, col: j, value: .undef)
                    
                    if tmpMove > bestMove {
                        bestMove = tmpMove
                        bestMoveRow = i
                        bestMoveCol = j
                    }
                }
            }
        }
        
        // Make best move (simulate tap)
        gameBoard.getTile(row: bestMoveRow, col: bestMoveCol).tileTapped()
    }
    
    // MARK: - Private methods
    private func evaluateBoard(gameBoard: GameBoard) -> Int {
        if gameBoard.isWon() {
            let currentTurn = gameBoard.getCurrentTurn()
            
            return currentTurn == self.symboleAI ? 10 : -10
        }
        
        return 0
    }
    
    private func minimax(gameBoard: GameBoard, depth: Int, isMaximizer: Bool) -> Int {
        // Check whether board is in terminal state
        let boardScore = evaluateBoard(gameBoard: gameBoard)
    
        if boardScore != 0 { // WIN
            return boardScore
        } else if gameBoard.isFullyFilled() { // TIE
            return 0
        }
        
        // -------------- MAXIMIZER --------------
        if isMaximizer {
            var bestMove = Int.min
            
            // Check move for every empty tile
            let boardSize = gameBoard.getBoardSize()
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    // Check whether tile is empty
                    if gameBoard.getTile(row: i, col: j).getTileState() == .undef {
                        // Make move
                        gameBoard.setTile(row: i, col: j, value: self.symboleAI)
                        
                        // Recursively call minimax
                        bestMove = max(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer))
                        
                        // Undo move
                        gameBoard.setTile(row: i, col: j, value: .undef)
                    }
                }
            }
            
            return bestMove
        }
        // -------------- MINIMIZER --------------
        else {
            var bestMove = Int.max
            
            // Check move for every empty tile
            let boardSize = gameBoard.getBoardSize()
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    // Check whether tile is empty
                    if gameBoard.getTile(row: i, col: j).getTileState() == .undef {
                        // Make move
                        gameBoard.setTile(row: i, col: j, value: self.symboleAI)
                        
                        // Recursively call minimax
                        bestMove = min(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer))
                        
                        // Undo move
                        gameBoard.setTile(row: i, col: j, value: .undef)
                    }
                }
            }
            
            return bestMove
        }
    }
}
