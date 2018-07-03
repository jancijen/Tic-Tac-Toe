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
    
    func isWon() -> Bool {
        // Rows check
        for i in 0..<self.boardSize {
            if sameSymbolsRow(row: i) {
                return true
            }
        }
        
        // Columns check
        for i in 0..<self.boardSize {
            if sameSymbolsColumn(column: i) {
                return true
            }
        }
        
        // Diagonals check
        return sameSymbolsDiag()
    }
    
    func isFullyFilled() -> Bool {
        return self.filledTiles == self.boardSize * self.boardSize // TODO - pow?
    }
    
    // MARK: - Private methods
    private func sameSymbolsRow(row: Int) -> Bool {
        let symbol = self.board[row][0].getTileState()
        
        if symbol == .undef {
            return false
        }
        
        for i in self.board[row] {
            if i.getTileState() != symbol {
                return false
            }
        }
        
        return true
    }
    
    private func sameSymbolsColumn(column: Int) -> Bool {
        let symbol = self.board[0][column].getTileState()
        
        if symbol == .undef {
            return false
        }
        
        for i in 1..<self.boardSize {
            if self.board[i][column].getTileState() != symbol {
                return false
            }
        }
        
        return true
    }
    
    private func sameSymbolsDiag() -> Bool {
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
            return true
        }
        
        symbol = self.board[0][self.boardSize - 1].getTileState()
        if symbol == .undef {
            return false
        }
        var col = self.boardSize - 2
        for i in 1..<self.boardSize {
            if self.board[i][col].getTileState() != symbol {
                return false
            }
            col -= 1
        }
        
        return true
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
