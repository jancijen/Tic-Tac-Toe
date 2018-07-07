//
//  Game.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func setTileView(row: Int, col: Int, value: Player) -> Void
}

/// Model representing game logic and data.
class Game {
    // MARK: - Public attributes
    weak var gameVCDelegate: GameDelegate? = nil
    // MARK: - Private attributes
    private let boardSize: Int
    private let firstPlayer: Player
    private let aiPlayer: Player
    private let AI: GameAI?
    private var state: GameState {
        didSet {
            // Post that state has been changed
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gameState"), object: nil, userInfo: ["newState": state])
        }
    }
    private let gameBoardModel: GameBoardModel
    
    // MARK: - Public methods
    init(boardSize: Int, firstPlayer: Player, aiPlayer: Player) {
        // General
        self.boardSize = boardSize
        self.firstPlayer = firstPlayer
        self.gameBoardModel = GameBoardModel(boardSize: self.boardSize)
        
        switch self.firstPlayer {
        case .X:
            self.state = .turnX
        case .O:
            self.state = .turnO
        default:
            self.state = .tie // TODO
        }
        
        // AI
        self.aiPlayer = aiPlayer
        if self.aiPlayer != .undef {
            self.AI = GameAI(symboleAI: aiPlayer)
        } else {
            self.AI = nil
        }
        
        // Delegates
        self.gameBoardModel.gameDelegate = self
    }
    
    /**
     Select concrete tile.
     
     - parameter row: Row of tile to be selected.
     - parameter col: Column of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func selectTile(row: Int, col: Int) -> Player? {
        // Get player on turn
        let currentPlayer = self.state.playerOnTurn()
        // In case that game ended
        if currentPlayer == .undef {
            return nil
        }
        
        // Try to select tile
        if self.gameBoardModel.setTile(row: row, col: col, value: currentPlayer, force: false) {
            // End game check
            if let endState = self.gameBoardModel.gameEnd() {
                self.state = endState
            } else {
                // Switch turns
                self.state = self.state.oppositeTurn()
                
                // AI turn (if it is on turn)
                makeAITurnIfShould()
            }
            
            return currentPlayer
        }
        
        return nil
    }
    
    /**
     Let AI make a move if it is on turn.
     */
    func makeAITurnIfShould() {
        // Turn check
        if self.state == .turnX && self.aiPlayer == .X
           || self.state == .turnO && self.aiPlayer == .O
        {
            // Make a move
            self.AI?.makeBestMove(gameBoard: self.gameBoardModel)
        }
    }
    
    /**
     Get AI player.
     
     - returns: AI player.
     */
    func getAIPlayer() -> Player {
        return self.aiPlayer
    }
    
    /**
     Reset game model.
     */
    func resetGame() {
        // Reset gameboard model
        self.gameBoardModel.reset()
        // Reset gamestate
        self.state = self.firstPlayer.turn()
        
        // Let AI start if it shouls
        makeAITurnIfShould()
    }
    
    // MARK: - Private methods
    /**
     Get player which is currently on turn.
     
     - returns: Player on turn.
     */
    private func getCurrentTurn() -> Player {
        switch self.state {
        case .turnX:
            return .X
        case .turnO:
            return .O
        default:
            return .undef
        }
    }
}

// MARK: - ModelDelegate
extension Game: ModelDelegate {
    func simulateTileTap(row: Int, col: Int) {
        let currentTurn = getCurrentTurn()
        
        // Model
        selectTile(row: row, col: col)
        // View
        gameVCDelegate?.setTileView(row: row, col: col, value: currentTurn)
    }
}
