//
//  GameBoardModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 6.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameBoardModelDelegate

protocol GameBoardModelDelegate: class {
    func gameBoardModel(_ gameBoardModel: GameBoardModel,
                        simulateTileTapAt position: Position) -> Void
}

// MARK: - GameBoardModel

/// Model representing gameboard's logic and data.
class GameBoardModel {
    // MARK: Public properties
    
    weak var delegate: GameBoardModelDelegate? = nil
    
    // MARK: Private properties
    private var filledTiles: Int = 0
    private var board: [[TileModel]] = [[TileModel]]()
    private let boardSize: Int
    
    // MARK: Initialization
    init(boardSize: Int) {
        self.boardSize = boardSize
        if boardSize < 3 { // TODO
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        // Initialize board
        for _ in 0..<self.boardSize {
            var row = [TileModel]()
            for _ in 0..<self.boardSize {
                row.append(TileModel())
            }
            
            self.board.append(row)
        }
    }
    
    // MARK: Public methods
    
    /**
     Get size of gameboard.
     
     - returns: Size of gameboard.
     */
    func getBoardSize() -> Int {
        return self.boardSize
    }
    
    /**
     Get concrete tile.
     
     - parameter position: Position of tile to get.
     
     - returns: Concrete tile.
     */
    func getTile(at position: Position) -> TileModel {
        return self.board[position.row][position.column]
    }
    
    /**
     Reset gameboard model.
     */
    func reset() {
        // Reset filled tiles count
        self.filledTiles = 0
        // Reset all tiles in board
        self.board = self.board.map { row -> [TileModel] in
            return row.map { tile -> TileModel in
                var retTile = tile
                retTile.reset()
                return retTile
            }
        }
    }
    
    /**
     Simulate tap on tile view.
     
     - parameter position: Position of tile to be tapped.
     */
    func simulateTap(at position: Position) {
        // Simulate view tap
        self.delegate?.gameBoardModel(self, simulateTileTapAt: position)
    }
    
    /**
     Set tile's symbol.
     
     - parameter position: Position of tile to be set.
     - parameter player: Mark of player to be set.
     - parameter force: Whether set should be forced even if tile is not empty.
     
     - returns: Whether mark was successfully set.
     */
    func setTile(at position: Position, to player: Player, force: Bool) -> Bool {
        // Try to set tile's symbol
        let toReturn = self.board[position.row][position.column].setTileSymbole(player: player, force: force)
        
        if toReturn {
            // Erasing marker
            if player == .undef {
                self.filledTiles -= 1
            }
            // Setting marker
            else {
                self.filledTiles += 1
            }
        }
        
        return toReturn
    }
    
    /**
     Get end gamestate if game has ended.
     
     - returns: End gamestate if game has ended, otherwise returns "nil".
     */
    func gameEnd() -> GameState? { // TODO - rename
        // Win check
        let winner = getWinner()
        if winner == .X {
            return .winX
        } else if winner == .O {
            return .winO
        }
        
        // Tie check
        if isFullyFilled() {
            return .tie
        }
        
        return nil
    }
    
    /**
     Get winner of current gameboard.
     
     - returns: Mark of winner if there is one, otherwise returns "undef".
     */
    func getWinner() -> Player {
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
    
    /**
     Check whether board is fully filled.
     
     - returns: Whether board is fully filled.
     */
    func isFullyFilled() -> Bool {
        return self.filledTiles == self.boardSize * self.boardSize
    }
    
    // MARK: Private methods
    
    /**
     Check row for same symbols.
     
     - parameter row: Row to be checked.
     
     - returns: Mark of player which is in whole row, otherwise returns "undef".
     */
    private func sameSymbolsRow(row: Int) -> Player {
        // First symbol
        let symbol = self.board[row][0].getTileSymbole()
        
        if symbol == .undef {
            return .undef
        }
        
        // Check next symbols
        for i in self.board[row] {
            if i.getTileSymbole() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    /**
     Check column for same symbols.
     
     - parameter column: Column to be checked.
     
     - returns: Mark of player which is in whole column, otherwise returns "undef".
     */
    private func sameSymbolsColumn(column: Int) -> Player {
        // First symbol
        let symbol = self.board[0][column].getTileSymbole()
        
        if symbol == .undef {
            return .undef
        }
        
        // Check next symbols
        for i in 1..<self.boardSize {
            if self.board[i][column].getTileSymbole() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    /**
     Check diagonals for same symbols.
     
     - returns: Mark of player which is in at least one whole diagonale, otherwise returns "undef".
     */
    private func sameSymbolsDiag() -> Player {
        var toReturn = true
        
        // -------- First diagonal --------
        // First symbol
        var symbol = self.board[0][0].getTileSymbole()
        
        if symbol == .undef {
            toReturn = false
        }
        
        // Check next symbols
        for i in 1..<self.boardSize {
            if self.board[i][i].getTileSymbole() != symbol {
                toReturn = false
                break
            }
        }
        
        if toReturn {
            return symbol
        }
        
        // -------- Second diagonal --------
        // Second symbol
        symbol = self.board[0][self.boardSize - 1].getTileSymbole()
        
        if symbol == .undef {
            return .undef
        }
        
        // Check next symbols
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

