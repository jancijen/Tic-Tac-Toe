//
//  Tile.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

/// Protocol defining required methods from game board.
protocol GameBoardViewDelegate {
    func selectTile(row: Int, col: Int) -> Player?
}

/// Representing one tile on game board.
class Tile: UIButton {
    // MARK: - Public attributes
    var gameBoardDelegate: GameBoardViewDelegate? = nil
    // MARK: - Static public attributes
    static let size: CGFloat = 100
    // MARK: - Private attributes
    private let row: Int
    private let col: Int
    
    // MARK: - Public methods
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        
        super.init(frame: CGRect(x: 0, y: 0, width: Tile.size, height: Tile.size))
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    /**
     Configure view and its subviews.
     */
    private func configure() {
        // Configure button
        self.backgroundColor = .white
        
        // Set button tap action
        self.addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
    }
}

// MARK: - Button callbacks
extension Tile {
    /**
     Callback to be called after tile has been tapped.
     */
    @objc func tileTapped() {
        guard let symbole = self.gameBoardDelegate?.selectTile(row: self.row, col: self.col) else { return }
        
        switch symbole {
        case .X:
            self.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        case .O:
            self.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        default:
            self.setImage(nil, for: .normal)
        }
    }
}
