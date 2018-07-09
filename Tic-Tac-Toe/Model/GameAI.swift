//
//  GameAI.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameAI

/// AI player.
class GameAI {
    // MARK: Private properties
    
    private let aiMark: Player
    
    // MARK: Initialization
    
    init(aiMark: Player) {
        self.aiMark = aiMark
    }
    
    // MARK: Public methods
    
    /**
     Makes best (optimal) move on given gameboard.
     
     - parameter gameBoard: Gameboard to make move on.
     */
    func makeBestMove(gameBoard: GameBoardModel) {
        let boardSize = gameBoard.boardSize
        
        var bestMove = Int.min
        var bestMoveRow = -1
        var bestMoveCol = -1
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let position = Position(row: row, column: col)
                
                // Check whether tile is empty
                if gameBoard.getTile(at: position).mark == .undef {
                    // Make move
                    gameBoard.setTile(at: position, to: aiMark, force: true)
                    
                    // Recursively call minimax
                    let tmpMove = minimax(gameBoard: gameBoard, depth: 0, isMaximizer: false, alpha: Int.min, beta: Int.max)
                    
                    // Undo move
                    gameBoard.setTile(at: position, to: .undef, force: true)
                    
                    if tmpMove > bestMove {
                        bestMove = tmpMove
                        bestMoveRow = row
                        bestMoveCol = col
                    }
                }
            }
        }
        
        // Make best move (simulate tap)
        gameBoard.tileTap(at: Position(row: bestMoveRow, column: bestMoveCol))
    }
    
    // MARK: Private methods
    
    /**
     Computes best move's score on given gameboard while trying to minimize the possible loss for a worst case scenario. Using minimax algorithm with alpha-beta pruning.
     
     - parameter gameBoard: Gameboard to make move on.
     - parameter depth: Current depth of minimax recursion.
     - parameter isMaximizer: Whether minimax is called by maximizer (otherwise minimizer).
     - parameter alpha: Alpha value for optimization.
     - parameter beta: Beta value for optimization.
     
     - returns: Best move's score on given gameboard.
     */
    private func minimax(gameBoard: GameBoardModel, depth: Int, isMaximizer: Bool, alpha: Int, beta: Int) -> Int {
        // Check whether board is in terminal state
        let winner = gameBoard.getWinner()
        // WIN
        if winner == .X || winner == .O {
            return winner == aiMark ? 10 : -10
        }
        // TIE
        else if gameBoard.isTied() {
            return 0
        }
        
        var alphaTmp = alpha
        var betaTmp = beta
        
        // -------------- MAXIMIZER --------------
        if isMaximizer {
            var bestMove = Int.min
            
            // Check move for every empty tile
            let boardSize = gameBoard.boardSize
            for row in 0..<boardSize {
                for col in 0..<boardSize {
                    let position = Position(row: row, column: col)
                    
                    // Check whether tile is empty
                    if gameBoard.getTile(at: position).mark == .undef {
                        // Make move
                        gameBoard.setTile(at: position, to: aiMark, force: true)
                        
                        // Recursively call minimax (depth trick to take shorter sequence of moves)
                        bestMove = max(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer, alpha: alphaTmp, beta: betaTmp) - depth)
                        
                        // Undo move
                        gameBoard.setTile(at: position, to: .undef, force: true)
                        
                        // Alpha-beta pruning optimization
                        alphaTmp = max(alphaTmp, bestMove)
                        if alphaTmp >= betaTmp {
                            return bestMove
                        }
                    }
                }
            }
            
            return bestMove
        }
        // -------------- MINIMIZER --------------
        else {
            var bestMove = Int.max
            
            // Check move for every empty tile
            let boardSize = gameBoard.boardSize
            for row in 0..<boardSize {
                for col in 0..<boardSize {
                    let position = Position(row: row, column: col)
                    
                    // Check whether tile is empty
                    if gameBoard.getTile(at: position).mark == .undef {
                        // Make move
                        gameBoard.setTile(at: position, to: aiMark.opposite(), force: true)
                        
                        // Recursively call minimax (depth trick to take shorter sequence of moves)
                        bestMove = min(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer, alpha: alphaTmp, beta: betaTmp) + depth)
                        
                        // Undo move
                        gameBoard.setTile(at: position, to: .undef, force: true)
                        
                        // Alpha-beta pruning optimization
                        betaTmp = min(betaTmp, bestMove)
                        if alphaTmp >= betaTmp {
                            return bestMove
                        }
                    }
                }
            }
            
            return bestMove
        }
    }
}
