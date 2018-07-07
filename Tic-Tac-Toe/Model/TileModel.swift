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
     
     - returns: Whether symbole was successfully set.
     */
    mutating func setTileSymbole(value: Player) -> Bool {
        if self.tileSymbole == .undef {
            self.tileSymbole = value
            return true
        }
        
        return false
    }
}
