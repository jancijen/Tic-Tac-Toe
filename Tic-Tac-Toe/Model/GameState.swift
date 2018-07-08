//
//  GameState.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameState

/// Possible states of game.
enum GameState {
    // MARK: Cases
    
    /// Player X is on turn
    case turnX
    /// Player O is on turn
    case turnO
    /// Player X has won
    case winX
    /// Player O has won
    case winO
    /// Game is tied
    case tie
    
    // MARK: Public methods
    
    /**
     Get player on turn according from game state.
     
     - returns: Player on turn.
     */
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
    
    /**
     Get opposite turn.
     
     - returns: Opposite turn if GameState is turn, else return itself.
     */
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
