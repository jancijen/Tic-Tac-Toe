//
//  GameBoardModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 6.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

/// Possible game states
enum GameState {
    case winX
    case winO
    case tie
    case notFinished
}

class GameBoardModel {
    // MARK: - Private attributes
    private var board: [[TileModel]] = [[TileModel]]()
    private let boardSize: Int
    private var filledTiles: Int = 0
    
    // MARK: - Public methods
    init(boardSize: Int) {
        self.boardSize = boardSize
        
        if boardSize < 3 { // TODO
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
    }
    
    func getBoardSize() -> Int {
        return self.boardSize
    }
    
    func getTile(row: Int, col: Int) -> TileModel {
        return self.board[row][col]
    }
    
    func isWon() -> Player {
        // Rows check
        for i in 0..<self.boardSize {
            let rowWinner = sameSymbolsRow(row: i)
            if rowWinner != .undef {
                return rowWinner
            }
        }
        
        // Columns check
        for i in 0..<self.boardSize {
            let colWinner = sameSymbolsColumn(column: i)
            if colWinner != .undef {
                return colWinner
            }
        }
        
        // Diagonals check
        return sameSymbolsDiag()
    }
    
    // TODO
    func noEmptyTiles() -> Bool {
        // Check whether whole board is filled
        for (_,row) in self.board.enumerated() {
            for (_,tile) in row.enumerated() {
                if tile.getTileSymbole() == .undef {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isFullyFilled() -> Bool {
        return self.filledTiles == self.boardSize * self.boardSize // TODO - pow?
    }
    
    func reset() {
        self.filledTiles = 0
        // Reset all tiles in board
        self.board = self.board.map { row -> [TileModel] in
            return row.map { tile -> TileModel in
                var retTile = tile
                retTile.reset()
                return retTile
            }
        }
        // TODO
    }
    
    // MARK: - Private methods
    private func sameSymbolsRow(row: Int) -> Player {
        let symbol = self.board[row][0].getTileSymbole()
        
        if symbol == .undef {
            return .undef
        }
        
        for i in self.board[row] {
            if i.getTileSymbole() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    private func sameSymbolsColumn(column: Int) -> Player {
        let symbol = self.board[0][column].getTileSymbole()
        
        if symbol == .undef {
            return .undef
        }
        
        for i in 1..<self.boardSize {
            if self.board[i][column].getTileSymbole() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    private func sameSymbolsDiag() -> Player {
        var toReturn = true
        
        var symbol = self.board[0][0].getTileSymbole()
        if symbol == .undef {
            toReturn = false
        }
        for i in 1..<self.boardSize {
            if self.board[i][i].getTileSymbole() != symbol {
                toReturn = false
                break
            }
        }
        
        if toReturn {
            return symbol
        }
        
        symbol = self.board[0][self.boardSize - 1].getTileSymbole()
        if symbol == .undef {
            return .undef
        }
        var col = self.boardSize - 2
        for i in 1..<self.boardSize {
            if self.board[i][col].getTileSymbole() != symbol {
                return .undef
            }
            col -= 1
        }
        
        return symbol
    }
}

