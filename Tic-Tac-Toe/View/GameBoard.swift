//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// Protocol defining required methods from game view controller.
protocol GameViewControllerDelegate: class {
    func selectTile(row: Int, col: Int) -> Player?
}

/// View representing game board.
class GameBoard: UIView {
    // MARK: - Public attributes
    weak var gameVCDelegate: GameViewControllerDelegate? = nil
    // MARK: - Private attributes
    private let boardSize: Int
    private var tiles: [[Tile]]
    
    // MARK: - Public attributes
    init(boardSize: Int) {
        self.boardSize = boardSize
        if self.boardSize < 3 { // TODO
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        self.tiles = [[Tile]]()
        
        super.init(frame: CGRect.zero) // TODO
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Reset gameboard to default.
     */
    func reset() {
        // Reset tile views
        for (_,row) in self.tiles.enumerated() {
            for (_,tile) in row.enumerated() {
                // Set tile to be blank
                tile.setImage(nil, for: .normal)
            }
        }
    }
    
    /**
     Set tile's view accordingly.
     
     - parameter row: Row of tile to set.
     - parameter col: Column of tile to set.
     - parameter player: Mark to be set.
     */
    func setTileView(row: Int, col: Int, player: Player) {
        // Get correct image
        let image: UIImage?
        if player == .X {
            image = #imageLiteral(resourceName: "cross")
        } else if player == .O {
            image = #imageLiteral(resourceName: "circle")
        } else {
            image = nil
        }
        
        // Set tile's image
        self.tiles[row][col].setImage(image, for: .normal)
    }
    
    // MARK: - Private methods
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
            
            var tmpRow = [Tile]()
            for col in 0..<boardSize {
                let tile = Tile(row: row, col: col)
                tile.gameBoardDelegate = self
                
                tmpRow.append(tile)
                horizontalSV.addArrangedSubview(tile)
            }
            
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
extension GameBoard: GameBoardViewDelegate {
    /**
     Select concrete tile.
     
     - parameter row: Row of tile to be selected.
     - parameter col: Column of tile to be selected.
     
     - returns: Player which is now marked on tile or "nil" if selection was not possible.
     */
    func selectTile(row: Int, col: Int) -> Player? {
        return self.gameVCDelegate?.selectTile(row: row, col: col)
    }
}
