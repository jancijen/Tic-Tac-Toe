//
//  GameAI.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameAI

/// AI "player" based on MiniMax algorithm.
class GameAI {
    // MARK: Private properties
    
    private let symboleAI: Player
    
    // MARK: Initialization
    
    init(symboleAI: Player) {
        self.symboleAI = symboleAI
    }
    
    // MARK: Public methods
    
    /**
     Make best (optimal) move on given gameboard.
     
     - parameter gameBoard: Game board to make move on.
     */
    func makeBestMove(gameBoard: GameBoardModel) {
        let boardSize = gameBoard.getBoardSize()
        
        var bestMove = Int.min
        var bestMoveRow = -1
        var bestMoveCol = -1
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let position = Position(row: row, column: col)
                
                // Check whether tile is empty
                if gameBoard.getTile(at: position).getTileSymbole() == .undef {
                    // Make move
                    gameBoard.setTile(at: position, to: self.symboleAI, force: true)
                    
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
        gameBoard.simulateTap(at: Position(row: bestMoveRow, column: bestMoveCol))
    }
    
    // MARK: Private methods
    
    /**
     Compute best worstcase scenario score on given board using minimax algorithm with alpha-beta prunning.
     
     - parameter gameBoard: Game board to make move on.
     - parameter depth: Depth of minimax recursion.
     - parameter isMaximizer: Whether minimax is called by maximizer (otherwise minimizer).
     - parameter alpha: Alpha value for optimization.
     - parameter beta: Beta value for optimization.
     
     - returns: Best worstcase scenario score on given board.
     */
    private func minimax(gameBoard: GameBoardModel, depth: Int, isMaximizer: Bool, alpha: Int, beta: Int) -> Int {
        // Check whether board is in terminal state
        let winner = gameBoard.getWinner()
        if winner == .X || winner == .O { // WIN
            return winner == self.symboleAI ? 10 : -10
        }
        else if gameBoard.isFullyFilled() { // TIE
            return 0
        }
        
        var alphaTmp = alpha
        var betaTmp = beta
        
        // -------------- MAXIMIZER --------------
        if isMaximizer {
            var bestMove = Int.min
            
            // Check move for every empty tile
            let boardSize = gameBoard.getBoardSize()
            for row in 0..<boardSize {
                for col in 0..<boardSize {
                    let position = Position(row: row, column: col)
                    
                    // Check whether tile is empty
                    if gameBoard.getTile(at: position).getTileSymbole() == .undef {
                        // Make move
                        gameBoard.setTile(at: position, to: self.symboleAI, force: true)
                        
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
            let boardSize = gameBoard.getBoardSize()
            for row in 0..<boardSize {
                for col in 0..<boardSize {
                    let position = Position(row: row, column: col)
                    
                    // Check whether tile is empty
                    if gameBoard.getTile(at: position).getTileSymbole() == .undef {
                        // Make move
                        gameBoard.setTile(at: position, to: self.symboleAI.opposite(), force: true)
                        
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
