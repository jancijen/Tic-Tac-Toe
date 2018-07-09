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

/// A set of methods which allows the delegate to manage user interaction.
protocol TileDelegate: class {
    func tile(_ tile: Tile, didSelectTileAt position: Position) -> Mark?
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
    
    /**
     Initializes new tile.
     
     - parameter position: Position of tile on gameboard.
     */
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
     Configures view and its subviews.
     */
    private func configure() {
        // Configure button
        backgroundColor = .white
        self.snp.makeConstraints { make in
            make.height.width.equalTo(Tile.size)
        }
        
        // Set button's tap action
        addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
    }
}

// MARK: - Buttons callbacks

extension Tile {
    /**
     Sets mark on tile accordingly. Method to be called after tile has been tapped.
     */
    @objc func tileTapped() {
        // Select tile if it is possible and get mark which should be set
        guard let mark = delegate?.tile(self, didSelectTileAt: position) else { return }
        
        // If tile has been selected - set its mark
        switch mark {
        case .X:
            setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        case .O:
            setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        default:
            setImage(nil, for: .normal)
        }
    }
}
