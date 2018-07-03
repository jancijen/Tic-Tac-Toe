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
                tile.currentTurnCallback = self.currentTurnCallback

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
}
