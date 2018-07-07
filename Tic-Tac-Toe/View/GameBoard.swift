//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate {
    func selectTile(row: Int, col: Int) -> Player?
}

/// View representing game board.
class GameBoard: UIView {
    // MARK: - Public attributes
    var gameVCDelegate: GameViewControllerDelegate? = nil
    // MARK: - Private attributes
    private let boardSize: Int
    
    // MARK: - Public attributes
    init(boardSize: Int) {
        self.boardSize = boardSize
        if self.boardSize < 3 { // TODO
            fatalError("GameBoard has to be at least 3 tiles in size.")
        }
        
        super.init(frame: CGRect.zero) // TODO
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
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
            
            for col in 0..<boardSize {
                let tile = Tile(row: row, col: col)
                tile.gameBoardDelegate = self
                
                horizontalSV.addArrangedSubview(tile)
            }
            
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
    func selectTile(row: Int, col: Int) -> Player? {
        return self.gameVCDelegate?.selectTile(row: row, col: col)
    }
}
