//
//  GameState.swift
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
