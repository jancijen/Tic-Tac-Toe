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
//        let boardSize = gameBoard.getBoardSize()
//
//        var bestMove = -1000//Int.min
//        var bestMoveRow = -1
//        var bestMoveCol = -1
//
//        for i in 0..<boardSize {
//            for j in 0..<boardSize {
//                // Check whether tile is empty
//                if gameBoard.getTile(row: i, col: j).getTileState() == .undef {
//                    // Make move
//                    gameBoard.setTile(row: i, col: j, value: self.symboleAI)
//
//                    // Recursively call minimax
//                    let tmpMove = minimax(gameBoard: gameBoard, depth: 0, isMaximizer: false)
//
//                    // Undo move
//                    gameBoard.setTile(row: i, col: j, value: .undef)
//
//                    if tmpMove > bestMove {
//                        bestMove = tmpMove
//                        bestMoveRow = i
//                        bestMoveCol = j
//                    }
//                }
//            }
//        }
        
        let bestMove = minimax(gameBoard: gameBoard, depth: 0, player: self.symboleAI)
        
        // Make best move (simulate tap)
        gameBoard.getTile(row: bestMove.moveRow(), col: bestMove.moveCol()).tileTapped()
    }
    
    // MARK: - Private methods
    private func evaluateBoard(gameBoard: GameBoard) -> Int {
        let winner = gameBoard.isWon()
        if winner != .undef {
            return winner == self.symboleAI ? 10 : -10
        }
        
        return 0
    }
    
    private func bestMoveIndex(from moves: [AIMove], isMaximizer: Bool) -> Int {
        // MAXIMIZER
        if isMaximizer {
            if let (maxIndex, _) = moves.enumerated().max(by: { $0.element.score < $1.element.score }) {
                return maxIndex
            } else {
                return -1 // TODO - empty array
            }
        }
        // MINIMIZER
        else {
            if let (minIndex, _) = moves.enumerated().min(by: { $0.element.score < $1.element.score }) {
                return minIndex
            } else {
                return -1 // TODO - empty array
            }
        }
    }
    
    private func minimax(gameBoard: GameBoard, depth: Int, player: Player) -> AIMove {
        // Check whether board is in terminal state
        let boardScore = evaluateBoard(gameBoard: gameBoard)
    
        if boardScore != 0 { // WIN
            // Optimization
            let toAdd = gameBoard.getCurrentTurn() == self.symboleAI ? depth : -1 * depth
            return AIMove(index: (-1, -1), score: boardScore + toAdd)
            //return boardScore
        } else if gameBoard.noEmptyTiles() { // TIE
            return AIMove(index: (-1, -1), score: 0)
        }
        
        var possibleMoves = [AIMove]()
        let boardSize = gameBoard.getBoardSize()
        
        // Iterate over empty tiles
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                // Check whether tile is empty
                if gameBoard.getTile(row: i, col: j).getTileState() == .undef {
                    // Current tmpMove
                    var tmpMove = AIMove()
                    tmpMove.index = (i, j)
                    
                    // Make move
                    gameBoard.setTile(row: i, col: j, value: player)
                    
                    // MAXIMIZER
                    if player == self.symboleAI {
                        tmpMove.score = minimax(gameBoard: gameBoard, depth: depth + 1, player: self.symboleAI.opposite()).score
                    }
                    // MINIMIZER
                    else {
                        tmpMove.score = minimax(gameBoard: gameBoard, depth: depth + 1, player: self.symboleAI).score
                    }
                    
                    // Undo move
                    gameBoard.setTile(row: i, col: j, value: .undef)
                    
                    // Add move to possible moves
                    possibleMoves.append(tmpMove)
                }
            }
        }
        
        var moveIndex: Int
        // -------------- MAXIMIZER --------------
        if player == self.symboleAI {
            moveIndex = bestMoveIndex(from: possibleMoves, isMaximizer: true)
        }
        // -------------- MINIMIZER --------------
        else {
            moveIndex = bestMoveIndex(from: possibleMoves, isMaximizer: false)
        }
        
        return possibleMoves[moveIndex]
    }
}
