//
//  Game.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameDelegate

/// Protocol defining required methods of game view controller.
protocol GameDelegate: class {
    func game(_ game: Game,
              setTileViewAt position: Position,
              to value: Player) -> Void
}

// MARK: - Game

/// Model representing game logic and data.
class Game {
    // MARK: Public properties
    
    weak var delegate: GameDelegate? = nil
    let aiPlayer: Player
    
    // MARK: Private properties
    
    private var state: GameState {
        didSet {
            // Post that state has been changed
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gameState"), object: nil, userInfo: ["newState": state])
            // Let AI make a move if it is on turn
            makeAIMoveIfShould()
        }
    }
    private let boardSize: Int
    private let firstPlayer: Player
    private let AI: GameAI?
    private let gameBoardModel: GameBoardModel
    
    // MARK: Initialization
    
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
        self.gameBoardModel.delegate = self
    }
    
    // MARK: Public methods
    
    /**
     Selects concrete tile.
     
     - parameter position: Position of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func selectTile(at position: Position) -> Player? {
        // Get player on turn
        let currentPlayer = self.state.playerOnTurn()
        // In case that game ended
        if currentPlayer == .undef {
            return nil
        }
        
        // Try to select tile
        if self.gameBoardModel.setTile(at: position, to: currentPlayer, force: false) {
            // End game check
            if let endState = self.gameBoardModel.gameEnd() {
                self.state = endState
            } else {
                // Switch turns
                self.state = self.state.oppositeTurn()
            }
            
            return currentPlayer
        }
        
        return nil
    }
    
    /**
     Resets game model.
     */
    func resetGame() {
        // Reset gameboard model
        self.gameBoardModel.reset()
        // Reset gamestate
        self.state = self.firstPlayer.turn()
    }
    
    // MARK: Private methods
    
    /**
     Getter for player which is currently on turn.
     
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

// MARK: - Observers callbacks

extension Game {
    /**
     Let AI make a move if it is on turn.
     */
    func makeAIMoveIfShould() {
        // Turn check
        if self.state == .turnX && self.aiPlayer == .X
            || self.state == .turnO && self.aiPlayer == .O
        {
            // Make a move
            self.AI?.makeBestMove(gameBoard: self.gameBoardModel)
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
