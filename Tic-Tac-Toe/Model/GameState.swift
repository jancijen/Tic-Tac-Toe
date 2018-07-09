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
    
    /// Player X is on turn.
    case turnX
    /// Player O is on turn.
    case turnO
    /// Player X has won.
    case winX
    /// Player O has won.
    case winO
    /// Game is tied.
    case tie
    /// Undefined.
    case undef
    
    // MARK: Public methods
    
    /**
     Getter for player on turn.
     
     - returns: Player on turn or "undef" if game has ended.
     */
    func playerOnTurn() -> Mark {
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
     Getter for opposite turn.
     
     - returns: Opposite turn or itself if game has ended.
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
