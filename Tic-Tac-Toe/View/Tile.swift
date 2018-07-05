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
protocol GameBoardDelegate {
    func getCurrentTurn() -> Player
    func nextTurn() -> Void
}

/// Representing one tile on game board.
class Tile: UIView {
    // MARK: - Public attributes
    var gameBoardDelegate: GameBoardDelegate? = nil
    // MARK: - Private attrbitues
    private let tileButton: UIButton = UIButton()
    private var tileSymbole: Player = .undef // TODO
    private let tileSize: CGFloat = 100
    
    // MARK: - Public methods
    init() {
        super.init(frame: CGRect.zero)
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.tileSymbole = .undef
        self.tileButton.setImage(nil, for: .normal)
    }
    
    /**
     Getter for symbole on tile.
     
     - returns: Symbole on tile.
     */
    func getTileSymbole() -> Player {
        return self.tileSymbole
    }
    
    /**
     Setter for symbole on tile.
     
     - parameter value: Value to be set.
     */
    func setTileSymbole(value: Player) {
        self.tileSymbole = value
    }
    
    // MARK: - Private methods
    /**
     Configure view and its subviews.
     */
    private func configure() {
        // Configure view
        self.backgroundColor = .white
        self.snp.makeConstraints { make in
            make.width.height.equalTo(self.tileSize)
        }
        
        // Create button over whole tile
        tileButton.backgroundColor = .white
        
        self.addSubview(tileButton)
        tileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Set button tap action
        tileButton.addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
    }
}

// MARK: - Button callbacks
extension Tile {
    /**
     Callback to be called after tile has been tapped.
     */
    @objc func tileTapped() {
        switch self.tileSymbole {
        case .undef:
            // Change tile state to symbole which is on turn
            if let delegate = self.gameBoardDelegate {
                let currentTurn = delegate.getCurrentTurn()
                
                switch currentTurn {
                case .X:
                    self.tileButton.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
                    self.tileSymbole = .X
                    self.gameBoardDelegate?.nextTurn()
                case .O:
                    self.tileButton.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
                    self.tileSymbole = .O
                    self.gameBoardDelegate?.nextTurn()
                default:
                    break
                }
            }
        default:
            // Do nothing (tile has been already tapped)
            break
        }
    }
}
