//
//  TileModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 7.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

struct TileModel {
    // MARK: - Private attributes
    private var tileSymbole: Player = .undef
    
    // MARK: - Public methods
    /**
     Reset tile to default.
     */
    mutating func reset() {
        self.tileSymbole = .undef
    }
    
    /**
     Getter for symbole on tile.
     
     - returns: Symbole on tile.
     */
    func getTileSymbole() -> Player {
        return self.tileSymbole
    }
    
    /**
     Setter for symbole on tile.
     
     - parameter value: Value to be set.
     
     - returns: Whether symbole was successfully set (tile was empty or set was forced).
     */
    mutating func setTileSymbole(value: Player, force: Bool) -> Bool {
        if self.tileSymbole == .undef || force {
            self.tileSymbole = value
            return true
        }
        
        return false
    }
}
