//
//  Player.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - Player

/// Possible symboles for player.
enum Player {
    // MARK: Cases
    
    case X
    case O
    case undef
    
    // MARK: - Public methods
    
    /**
     Get opposite symbole.
     
     - returns: Opposite symbole.
     */
    func opposite() -> Player {
        switch self {
        case .X:
            return .O
        case .O:
            return .X
        default:
            return .undef
        }
    }
    
    /**
     Get turn according to player.
     
     - returns: Turn of symbole.
     */
    func turn() -> GameState {
        switch self {
        case .X:
            return .turnX
        case .O:
            return .turnO
        default:
            return .tie // TODO
        }
    }
    
    /**
     Get win according to player.
     
     - returns: Win of symbole.
     */
    func win() -> GameState {
        switch self {
        case .X:
            return .winX
        case .O:
            return .winO
        default:
            return .tie // TODO
        }
    }
}
