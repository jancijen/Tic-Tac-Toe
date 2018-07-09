//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - GameBoardDelegate

/// A set of methods which allows the delegate to manage user interaction.
protocol GameBoardDelegate: class {
    func gameBoard(_ gameBoard: GameBoard, didSelectTileAt position: Position) -> Mark?
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
    
    /**
     Initializes new game board.
     
     - parameter boardSize: Size of gameboard.
     */
    init(boardSize: Int) {
        self.boardSize = boardSize
        if boardSize < 3 {
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        tiles = [[Tile]]()
        
        super.init(frame: CGRect.zero)
        
        // Initial setup
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public methods
    
    /**
     Resets gameboard to default.
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
     Sets mark on tile at given position.
     
     - parameter position: Position of tile to set mark on.
     - parameter mark: Mark to be set.
     */
    func setMark(at position: Position, to mark: Mark) {
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
        tiles[position.row][position.column].setImage(image, for: .normal)
    }
    
    // MARK: Private methods
    
    /**
     Configures view and its subviews.
     */
    private func configure() {
        // View configuration
        backgroundColor = .black
        
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
            tiles.append(tmpRow)
            verticalSV.addArrangedSubview(horizontalSV)
        }
        
        // Add rows of tiles as subview
        addSubview(verticalSV)
        verticalSV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: - GameBoardViewDelegate

extension GameBoard: TileDelegate {
    /**
     Tells the delegate that tile at given position has been selected.
     
     - parameter tile: The tile object informing the delegate of this event.
     - parameter position: Position of the selected tile.
     
     - returns: Player which is now marked on tile or "nil" if gameboard selection was not possible.
     */
    func tile(_ tile: Tile, didSelectTileAt position: Position) -> Mark? {
        return delegate?.gameBoard(self, didSelectTileAt: position)
    }
}
