//
//  Game.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

/// Possible game states.
enum GameState {
    case winX
    case winO
    case tie
    case turnX
    case turnO
    
    func playerOnTurn() -> Player {
        switch self {
        case .turnX:
            return .X
        case .turnO:
            return .O
        default:
            return .undef
        }
    }
    
    func oppositeTurn() -> GameState {
        switch self {
        case .turnX:
            return .turnO
        case .turnO:
            return .turnX
        default:
            return self
        }
    }
}

protocol GameDelegate: class {
    func setTileView(row: Int, col: Int, value: Player) -> Void
}

class Game {
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
    
    weak var gameVCDelegate: GameDelegate? = nil
    
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
    
    func selectTile(row: Int, col: Int) -> Player? {
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
                
                makeAITurnIfShould()
            }
            
            return currentPlayer
        }
        
        return nil
    }
    
    func makeAITurnIfShould() {
        // Let AI make a move if it is on turn
        if self.state == .turnX && self.aiPlayer == .X
           || self.state == .turnO && self.aiPlayer == .O
        {
            // Make a move
            self.AI?.makeBestMove(gameBoard: self.gameBoardModel)
        }
    }
    
    func getCurrentTurn() -> Player {
        switch self.state {
        case .turnX:
            return .X
        case .turnO:
            return .O
        default:
            return .undef
        }
    }
    
    func getAIPlayer() -> Player {
        return self.aiPlayer
    }
    
    func resetGame() {
        self.gameBoardModel.reset()
        self.state = self.firstPlayer.turn()
        
        makeAITurnIfShould()
    }
    
    // MARK: - Private methods
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
