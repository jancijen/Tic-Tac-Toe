//
//  Tile.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

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
    private var tileState: Player = .undef // TODO
    private let tileSize: CGFloat = 100
    
    // MARK: - Public methods
    init() {
        super.init(frame: CGRect.zero)
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTileState() -> Player {
        return self.tileState
    }
    
    // MARK: - Private methods
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
    @objc private func tileTapped() {
        switch self.tileState {
        case .undef:
            // Change tile state to corresponding symbol
            if let delegate = self.gameBoardDelegate {
                let currentTurn = delegate.getCurrentTurn()
                
                switch currentTurn {
                case .X:
                    self.tileButton.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
                    self.tileState = .X
                    self.gameBoardDelegate?.nextTurn()
                case .O:
                    self.tileButton.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
                    self.tileState = .O
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
