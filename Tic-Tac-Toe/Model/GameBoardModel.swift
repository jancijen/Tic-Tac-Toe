//
//  GameBoardModel.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 6.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

// MARK: - GameBoardModelDelegate

/// A set of methods used to manage "simulated" user (AI) interaction (to update view).
protocol GameBoardModelDelegate: class {
    func gameBoardModel(_ gameBoardModel: GameBoardModel, tapOnTileAt position: Position)
}

// MARK: - GameBoardModel

/// Model representing gameboard's logic and data.
class GameBoardModel {
    // MARK: Public properties
    
    weak var delegate: GameBoardModelDelegate? = nil
    let boardSize: Int
    
    // MARK: Private properties
    private var filledTilesCnt: Int = 0
    private var board: [[TileModel]] = [[TileModel]]()
    
    // MARK: Initialization
    init(boardSize: Int) {
        self.boardSize = boardSize
        if boardSize < 3 {
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        // Initialize board with empty tiles
        for _ in 0..<boardSize {
            var row = [TileModel]()
            for _ in 0..<boardSize {
                row.append(TileModel())
            }
            
            board.append(row)
        }
    }
    
    // MARK: Public methods
    
    /**
     Getter for concrete tile.
     
     - parameter position: Position of tile to get.
     
     - returns: Concrete tile.
     */
    func getTile(at position: Position) -> TileModel {
        return board[position.row][position.column]
    }
    
    /**
     Resets gameboard model.
     */
    func reset() {
        // Reset filled tiles count
        filledTilesCnt = 0
        
        // Reset all tiles in board
        board = board.map { row -> [TileModel] in
            return row.map { tile -> TileModel in
                var retTile = tile
                retTile.reset()
                return retTile
            }
        }
    }
    
    /**
     Taps on tile's view.
     
     - parameter position: Position of tile to be tapped.
     */
    func tileTap(at position: Position) {
        // Tap on tile's view at given position
        delegate?.gameBoardModel(self, tapOnTileAt: position)
    }
    
    /**
     Sets tile's mark.
     
     - parameter position: Position of tile to set mark on.
     - parameter mark: Mark of player to be set.
     - parameter force: Whether set should be forced even if tile is not empty.
     
     - returns: Whether mark was successfully set.
     */
    func setTile(at position: Position, to mark: Player, force: Bool) -> Bool {
        // Try to set tile's mark
        let setWasSuccessfull = board[position.row][position.column].setMark(to: mark, force: force)
        
        if setWasSuccessfull {
            // Erasing mark
            if mark == .undef {
                filledTilesCnt -= 1
            }
            // Setting mark
            else {
                filledTilesCnt += 1
            }
        }
        
        return setWasSuccessfull
    }
    
    /**
     Getter for end gamestate if game has ended.
     
     - returns: End gamestate if game has ended, otherwise "nil".
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
        if isTied() {
            return .tie
        }
        
        return nil
    }
    
    /**
     Getter for winner of current gameboard.
     
     - returns: Mark of winner if there is one, otherwise "undef".
     */
    func getWinner() -> Player {
        // Rows check
        for i in 0..<boardSize {
            let rowWinner = sameMarksRow(row: i)
            if rowWinner != .undef {
                return rowWinner
            }
        }
        
        // Columns check
        for i in 0..<boardSize {
            let colWinner = sameMarksColumn(column: i)
            if colWinner != .undef {
                return colWinner
            }
        }
        
        // Diagonals check
        return sameMarksDiag()
    }
    
    /**
     Checks whether game is tied.
     
     - returns: Whether game is tied.
     */
    func isTied() -> Bool {
        // Check whether gameboard is fully filled
        return filledTilesCnt == boardSize * boardSize
    }
    
    // MARK: Private methods
    
    /**
     Checks row for same marks.
     
     - parameter row: Row to be checked.
     
     - returns: Mark of player which is in whole row, otherwise "undef".
     */
    private func sameMarksRow(row: Int) -> Player {
        // First mark
        let mark = board[row][0].mark
        
        if mark == .undef {
            return .undef
        }
        
        // Check next marks
        for i in board[row] {
            if i.mark != mark {
                return .undef
            }
        }
        
        return mark
    }
    
    /**
     Checks column for same marks.
     
     - parameter column: Column to be checked.
     
     - returns: Mark of player which is in whole column, otherwise "undef".
     */
    private func sameMarksColumn(column: Int) -> Player {
        // First mark
        let mark = board[0][column].mark
        
        if mark == .undef {
            return .undef
        }
        
        // Check next marks
        for i in 1..<boardSize {
            if board[i][column].mark != mark {
                return .undef
            }
        }
        
        return mark
    }
    
    /**
     Checks diagonals for same marks.
     
     - returns: Mark of player which is in at least one whole diagonale, otherwise "undef".
     */
    private func sameMarksDiag() -> Player {
        var toReturn = true
        
        // -------- First diagonal --------
        // First mark
        var mark = board[0][0].mark
        
        if mark == .undef {
            toReturn = false
        }
        
        // Check next marks
        for i in 1..<boardSize {
            if board[i][i].mark != mark {
                toReturn = false
                break
            }
        }
        
        if toReturn {
            return mark
        }
        
        // -------- Second diagonal --------
        // Second mark
        mark = board[0][boardSize - 1].mark
        
        if mark == .undef {
            return .undef
        }
        
        // Check next marks
        var col = boardSize - 2
        for i in 1..<boardSize {
            if board[i][col].mark != mark {
                return .undef
            }
            col -= 1
        }
        
        return mark
    }
}

