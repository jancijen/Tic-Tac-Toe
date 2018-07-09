//
//  TileModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - TileModel

/// Model representing tile on gameboard.
struct TileModel {
    // MARK: Private(set) properties
    
    /// Mark on tile.
    private(set) var mark: Mark = .undef
    
    // MARK: Public methods
    
    /**
     Resets tile to default (blank).
     */
    mutating func reset() {
        mark = .undef
    }
    
    /**
     Setter for mark on tile.
     
     - parameter mark: Mark of which player to set on tile.
     - parameter force: Whether to force to set mark, even if the tile is not empty.
     
     - returns: Whether mark was successfully set (tile was empty or it was forced).
     */
    mutating func setMark(to mark: Mark, force: Bool) -> Bool {
        if self.mark == .undef || force {
            self.mark = mark
            return true
        }
        
        return false
    }
}
