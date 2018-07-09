//
//  Game.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameDelegate

/// A set of methods used to update view after model changes.
protocol GameDelegate: class {
    func game(_ game: Game,
              setTileViewAt position: Position,
              to mark: Mark)
}

// MARK: - Game

/// Model representing game logic and data.
class Game {
    // MARK: Public properties
    
    weak var delegate: GameDelegate? = nil
    let aiPlayer: Mark
    
    // MARK: Private properties
    
    private var state: GameState {
        didSet {
            // Post that state has been changed
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gameState"),
                                            object: nil,
                                            userInfo: ["newState": state])
            // Let AI make a move if it is on turn
            makeAIMoveIfShould()
        }
    }
    private let boardSize: Int
    private let firstPlayer: Mark
    private let AI: GameAI?
    private let gameBoardModel: GameBoardModel
    
    // MARK: Initialization
    
    init(boardSize: Int, firstPlayer: Mark, aiPlayer: Mark) {
        // General
        self.boardSize = boardSize
        self.firstPlayer = firstPlayer
        gameBoardModel = GameBoardModel(boardSize: boardSize)
        
        switch firstPlayer {
        case .X:
            state = .turnX
        case .O:
            state = .turnO
        default:
            state = .undef
        }
        
        // AI
        self.aiPlayer = aiPlayer
        if aiPlayer != .undef {
            AI = GameAI(aiMark: aiPlayer)
        } else {
            AI = nil
        }
        
        // Delegates
        gameBoardModel.delegate = self
    }
    
    // MARK: Public methods
    
    /**
     Selects concrete tile.
     
     - parameter position: Position of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func selectTile(at position: Position) -> Mark? {
        // Get player on turn
        let currentPlayer = state.playerOnTurn()
        // In case that game ended
        if currentPlayer == .undef {
            return nil
        }
        
        // Try to select tile
        if gameBoardModel.setTile(at: position, to: currentPlayer, force: false) {
            // End game check
            if let endState = gameBoardModel.getEndState() {
                state = endState
            } else {
                // Switch turns
                state = state.oppositeTurn()
            }
            
            return currentPlayer
        }
        
        return nil
    }
    
    /**
     Resets game model.
     */
    func reset() {
        // Reset gameboard model
        gameBoardModel.reset()
        // Reset gamestate
        state = firstPlayer.turn()
    }
    
    // MARK: Private methods
    
    /**
     Getter for player which is currently on turn.
     
     - returns: Player on turn.
     */
    private func getCurrentTurn() -> Mark {
        switch state {
        case .turnX:
            return .X
        case .turnO:
            return .O
        default:
            return .undef
        }
    }
}

// MARK: - Observers callbacks

extension Game {
    /**
     Let AI make a move if it is on turn.
     */
    func makeAIMoveIfShould() {
        // Turn check
        if state == .turnX && aiPlayer == .X
           || state == .turnO && aiPlayer == .O
        {
            // Make a move
            AI?.makeBestMove(gameBoard: gameBoardModel)
        }
    }
}


// MARK: - ModelDelegate

extension Game: GameBoardModelDelegate {
    /**
     Tap on tile.
     
     - parameter gameBoardModel: Gameboard model.
     - parameter position: Position of tile to be tapped.
     */
    func gameBoardModel(_ gameBoardModel: GameBoardModel, tapOnTileAt position: Position) {
        let currentTurn = getCurrentTurn()
        
        // Model tap - data/logic layer
        selectTile(at: position)
        
        // View tap - view layer
        delegate?.game(self, setTileViewAt: position, to: currentTurn)
    }
}
