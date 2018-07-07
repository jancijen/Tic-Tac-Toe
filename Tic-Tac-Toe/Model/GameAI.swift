//
//  GameAI.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

/// AI "player" based on MiniMax algorithm.
class GameAI {
    // MARK: - Private attributes
    private let symboleAI: Player
    
    // MARK: - Public methods
    init(symboleAI: Player) {
        self.symboleAI = symboleAI
    }
    
    func makeBestMove(gameBoard: GameBoardModel) {
        let boardSize = gameBoard.getBoardSize()
        
        var bestMove = Int.min
        var bestMoveRow = -1
        var bestMoveCol = -1
        
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                // Check whether tile is empty
                if gameBoard.getTile(row: i, col: j).getTileSymbole() == .undef {
                    // Make move
                    gameBoard.setTile(row: i, col: j, value: self.symboleAI, force: true)
                    
                    // Recursively call minimax
                    let tmpMove = minimax(gameBoard: gameBoard, depth: 0, isMaximizer: false, alpha: Int.min, beta: Int.max)
                    
                    // Undo move
                    gameBoard.setTile(row: i, col: j, value: .undef, force: true)
                    
                    if tmpMove > bestMove {
                        bestMove = tmpMove
                        bestMoveRow = i
                        bestMoveCol = j
                    }
                }
            }
        }
        
        // Make best move (simulate tap)
        gameBoard.simulateTap(row: bestMoveRow, col: bestMoveCol)
    }
    
    // MARK: - Private methods
    private func minimax(gameBoard: GameBoardModel, depth: Int, isMaximizer: Bool, alpha: Int, beta: Int) -> Int {
        // Check whether board is in terminal state
        let winner = gameBoard.isWon()
        if winner == .X || winner == .O { // WIN
            // Optimization
            //let toRet = winner == self.symboleAI ? 10 + depth : -10 + (-1 * depth)
            let toRet = winner == self.symboleAI ? 10 : -10
            return toRet
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
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    // Check whether tile is empty
                    if gameBoard.getTile(row: i, col: j).getTileSymbole() == .undef {
                        // Make move
                        gameBoard.setTile(row: i, col: j, value: self.symboleAI, force: true)
                        
                        // Recursively call minimax
                        bestMove = max(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer, alpha: alphaTmp, beta: betaTmp))// - depth)
                        
                        // Undo move
                        gameBoard.setTile(row: i, col: j, value: .undef, force: true)
                        
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
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    // Check whether tile is empty
                    if gameBoard.getTile(row: i, col: j).getTileSymbole() == .undef {
                        // Make move
                        gameBoard.setTile(row: i, col: j, value: self.symboleAI.opposite(), force: true)
                        
                        // Recursively call minimax
                        bestMove = min(bestMove, minimax(gameBoard: gameBoard, depth: depth + 1, isMaximizer: !isMaximizer, alpha: alphaTmp, beta: betaTmp))// + depth)
                        
                        // Undo move
                        gameBoard.setTile(row: i, col: j, value: .undef, force: true)
                        
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
