//
//  Tile.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 3.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit
import SnapKit

/// Representing one tile on game board.
class Tile: UIView {
    // MARK: - Public attributes
    var currentTurnCallback: (() -> Player)? = nil
    // MARK: - Private attrbitues
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
    
    // MARK: - Private methods
    private func configure() {
        // Configure view
        self.backgroundColor = .white
        self.snp.makeConstraints { make in
            make.width.height.equalTo(self.tileSize)
        }
        
        // Create button over whole tile
        let tileButton = UIButton()
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
        print("TILE TAPPED")
        switch self.tileState {
        case .undef:
            // Change tile state to corresponding symbol
            if let currTurnCallback = self.currentTurnCallback {
                let currentTurn = currTurnCallback()
                
                // TODO
                switch currentTurn {
                case .X:
                    break
                case .O:
                    break
                default:
                    break
                }
                break
            }
        default:
            // Do nothing (tile has been already tapped)
            break
        }
    }
}
