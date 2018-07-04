//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate {
    func getCurrentTurn() -> Player
    func nextTurn() -> Void
}

/// Possible game states
enum GameState {
    case winX
    case winO
    case tie
    case notFinished
}

/// View representing game board.
class GameBoard: UIView {
    // MARK: - Public attributes
    var gameVCDelagate: GameViewControllerDelegate? = nil
    // MARK: - Private attributes
    private var board: [[Tile]] = [[Tile]]()
    private let boardSize: Int
    private var filledTiles: Int = 0
    
    // MARK: - Public methods
    init(boardSize: Int) {
        self.boardSize = boardSize
        
        if boardSize < 3 { // TODO
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        super.init(frame: CGRect.zero) // TODO
        
        // View configuration
        self.backgroundColor = .black
        
        // Verical stack view for rows of tiles
        let verticalSV = UIStackView()
        verticalSV.axis = .vertical
        verticalSV.distribution = .equalSpacing
        verticalSV.alignment = .center
        verticalSV.spacing = 4.0
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        
        // Create empty board and add tiles to stack views
        for _ in 0..<boardSize {
            var tmpArray = [Tile]()
            
            // Horizontal stack view - row of tiles
            let horizontalSV = UIStackView()
            horizontalSV.axis = .horizontal
            horizontalSV.distribution = .equalSpacing
            horizontalSV.alignment = .center
            horizontalSV.spacing = 4.0
            horizontalSV.translatesAutoresizingMaskIntoConstraints = false
            
            for _ in 0..<boardSize {
                let tile = Tile()
                tile.gameBoardDelegate = self
                
                tmpArray.append(tile)
                horizontalSV.addArrangedSubview(tile)
            }
            
            self.board.append(tmpArray)
            verticalSV.addArrangedSubview(horizontalSV)
        }
        
        // Add rows of tiles as subview
        self.addSubview(verticalSV)
        verticalSV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getBoardSize() -> Int {
        return self.boardSize
    }
    
    func getTile(row: Int, col: Int) -> Tile {
        return self.board[row][col]
    }
 
    func setTile(row: Int, col: Int, value: Player){
        self.board[row][col].setTileState(value: value)
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
                if tile.getTileState() != .undef {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isFullyFilled() -> Bool {
        return self.filledTiles == self.boardSize * self.boardSize // TODO - pow?
    }
    
    // MARK: - Private methods
    private func sameSymbolsRow(row: Int) -> Player {
        let symbol = self.board[row][0].getTileState()
        
        if symbol == .undef {
            return .undef
        }
        
        for i in self.board[row] {
            if i.getTileState() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    private func sameSymbolsColumn(column: Int) -> Player {
        let symbol = self.board[0][column].getTileState()
        
        if symbol == .undef {
            return .undef
        }
        
        for i in 1..<self.boardSize {
            if self.board[i][column].getTileState() != symbol {
                return .undef
            }
        }
        
        return symbol
    }
    
    private func sameSymbolsDiag() -> Player {
        var toReturn = true
        
        var symbol = self.board[0][0].getTileState()
        if symbol == .undef {
            toReturn = false
        }
        for i in 1..<self.boardSize {
            if self.board[i][i].getTileState() != symbol {
                toReturn = false
                break
            }
        }
        
        if toReturn {
            return symbol
        }
        
        symbol = self.board[0][self.boardSize - 1].getTileState()
        if symbol == .undef {
            return .undef
        }
        var col = self.boardSize - 2
        for i in 1..<self.boardSize {
            if self.board[i][col].getTileState() != symbol {
                return .undef
            }
            col -= 1
        }
        
        return symbol
    }
}

// MARK: - GameBoardDelegate
extension GameBoard: GameBoardDelegate {
    func getCurrentTurn() -> Player {
        if let delegate = gameVCDelagate {
            return delegate.getCurrentTurn()
        }
        
        return .undef
    }
    
    func nextTurn() {
        self.filledTiles += 1
        self.gameVCDelagate?.nextTurn()
    }
}
