//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - GameBoardDelegate

/// Protocol defining required methods of game view controller.
protocol GameBoardDelegate: class {
    func gameBoard(_ gameBoard: GameBoard,
                   didSelectTileAt position: Position) -> Player?
}

// MARK: - GameBoard

/// View representing gameboard.
class GameBoard: UIView {
    // MARK: Public properties
    
    weak var delegate: GameBoardDelegate? = nil
    
    // MARK: Private properties
    
    private var tiles: [[Tile]]
    private let boardSize: Int
    
    // MARK: Initialization
    
    init(boardSize: Int) {
        self.boardSize = boardSize
        if self.boardSize < 3 {
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        self.tiles = [[Tile]]()
        
        super.init(frame: CGRect.zero) // TODO
        
        // Initial setup
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public methods
    
    /**
     Reset gameboard to default.
     */
    func reset() {
        // Reset tiles views
        for (_, row) in tiles.enumerated() {
            for (_, tile) in row.enumerated() {
                // Set tile to be blank
                tile.setImage(nil, for: .normal)
            }
        }
    }
    
    /**
     Set mark on tile at given position.
     
     - parameter position: Position of tile to set mark on.
     - parameter mark: Mark to be set.
     */
    func setMark(at position: Position, to mark: Player) {
        // Get correct image
        let image: UIImage?
        if mark == .X {
            image = #imageLiteral(resourceName: "cross")
        } else if mark == .O {
            image = #imageLiteral(resourceName: "circle")
        } else {
            image = nil
        }
        
        // Set tile's image
        self.tiles[position.row][position.column].setImage(image, for: .normal)
    }
    
    // MARK: Private methods
    
    /**
     Configure view and its subviews.
     */
    private func configure() {
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
        for row in 0..<boardSize {
            // Horizontal stack view - row of tiles
            let horizontalSV = UIStackView()
            horizontalSV.axis = .horizontal
            horizontalSV.distribution = .equalSpacing
            horizontalSV.alignment = .center
            horizontalSV.spacing = 4.0
            horizontalSV.translatesAutoresizingMaskIntoConstraints = false
            
            // Fill row with tiles
            var tmpRow = [Tile]()
            for col in 0..<boardSize {
                let tile = Tile(position: Position(row: row, column: col))
                tile.delegate = self
                
                tmpRow.append(tile)
                horizontalSV.addArrangedSubview(tile)
            }
            
            // Add row to vertical stack view
            self.tiles.append(tmpRow)
            verticalSV.addArrangedSubview(horizontalSV)
        }
        
        // Add rows of tiles as subview
        self.addSubview(verticalSV)
        verticalSV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: - GameBoardViewDelegate

extension GameBoard: TileDelegate {
    /**
     Select concrete tile.
     
     - parameter tile:
     - parameter position: Position of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func tile(_ tile: Tile, didSelectTileAt position: Position) -> Player? {
        return self.delegate?.gameBoard(self, didSelectTileAt: position)
    }
}
