//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// View representing game board.
class GameBoard: UIView {
    // MARK: - Public attributes
    var currentTurnCallback: (() -> Player)? = nil
    // MARK: - Private attributes
    private var board: [[Tile]] = [[Tile]]()
    
    // MARK: - Public methods
    init(boardSize: Int) {
        super.init(frame: CGRect.zero) // TODO
        
        // Create empty board
        for _ in 0...boardSize {
            var tmpArray = [Tile]()
            for _ in 0...boardSize {
                let tile = Tile()
                tile.currentTurnCallback = self.currentTurnCallback

                tmpArray.append(tile)
            }
            
            self.board.append(tmpArray)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
