//
//  Mark.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - Mark

/// Possible marks for player.
enum Mark {
    // MARK: Cases
    
    /// Player X.
    case X
    /// Player O.
    case O
    /// Undefined/Blank.
    case undef
    
    // MARK: - Public methods
    
    /**
     Getter for opposite mark.
     
     - returns: Opposite mark.
     */
    func opposite() -> Mark {
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
     Getter for turn according to player.
     
     - returns: Turn of mark.
     */
    func turn() -> GameState {
        switch self {
        case .X:
            return .turnX
        case .O:
            return .turnO
        default:
            return .undef
        }
    }
    
    /**
     Getter for win according to player.
     
     - returns: Win of mark.
     */
    func win() -> GameState {
        switch self {
        case .X:
            return .winX
        case .O:
            return .winO
        default:
            return .undef
        }
    }
}
