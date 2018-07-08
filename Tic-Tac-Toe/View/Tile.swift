//
//  Tile.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - TileDelegate

/// Protocol defining required methods of gameboard.
protocol TileDelegate: class {
    func tile(_ tile: Tile, didSelectTileAt position: Position) -> Player?
}

// MARK: - Tile

/// Button representing tile on gameboard.
class Tile: UIButton {
    // MARK: Public properties
    
    weak var delegate: TileDelegate? = nil
    
    // MARK: Private properties
    
    static private let size: CGFloat = 100
    private let position: Position
    
    // MARK: Initialization
    
    init(position: Position) {
        self.position = position
        
        super.init(frame: CGRect.zero)
        
        // Initial setup
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    /**
     Configure view and its subviews.
     */
    private func configure() {
        // Configure button
        self.backgroundColor = .white
        self.snp.makeConstraints { make in
            make.height.width.equalTo(Tile.size)
        }
        
        // Set button's tap action
        self.addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
    }
}

// MARK: - Buttons callbacks

extension Tile {
    /**
     Set mark on tile accordingly. Method to be called after tile has been tapped.
     */
    @objc func tileTapped() {
        // Select tile if it is possible and get mark which should be set
        guard let mark = delegate?.tile(self, didSelectTileAt: position) else { return }
        
        // If tile has been selected - set its mark
        switch mark {
        case .X:
            self.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        case .O:
            self.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        default:
            self.setImage(nil, for: .normal)
        }
    }
}
