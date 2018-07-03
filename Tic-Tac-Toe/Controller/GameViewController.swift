//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 30.6.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Private attributes
    private let playersSymbole: Player
    private let currentTurn: Player
    private let gameBoard: GameBoard
    
    // MARK: - Public methods
    init(boardSize: Int, firstTurn: Player, playersSymbole: Player) {
        self.playersSymbole = playersSymbole
        self.currentTurn = firstTurn
        self.gameBoard = GameBoard(boardSize: boardSize)
        
        super.init(nibName: nil, bundle: nil)
        self.gameBoard.currentTurnCallback = { return self.currentTurn }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
}
