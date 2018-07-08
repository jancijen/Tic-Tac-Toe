//
//  TileModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - TileModel

/// Model representing data of tile on gameboard.
struct TileModel {
    // MARK: Private properties
    
    private var tileSymbole: Player = .undef
    
    // MARK: Public methods
    
    /**
     Getter for symbole on tile.
     
     - returns: Symbole on tile.
     */
    func getTileSymbole() -> Player {
        return self.tileSymbole
    }
    
    /**
     Reset tile to default.
     */
    mutating func reset() {
        self.tileSymbole = .undef
    }
    
    /**
     Setter for symbole on tile.
     
     - parameter player: Symbole of which player to set on tile.
     - parameter force: Whether to force to set symbole, even if tile is not empty.
     
     - returns: Whether symbole was successfully set (tile was empty or set was forced).
     */
    mutating func setTileSymbole(player: Player, force: Bool) -> Bool {
        if self.tileSymbole == .undef || force {
            self.tileSymbole = player
            return true
        }
        
        return false
    }
}
