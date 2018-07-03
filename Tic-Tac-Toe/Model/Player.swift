//
//  Player.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

/// Possible symboles for player.
enum Player {
    case X
    case O
    case undef
    
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
}
