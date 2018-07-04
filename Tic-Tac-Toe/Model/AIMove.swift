//
//  AIMove.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 4.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation

struct AIMove {
    var index: (Int, Int) = (-1, -1) // todo
    var score: Int = -1 // todo
    
    func moveRow() -> Int {
        return index.0
    }
    
    func moveCol() -> Int {
        return index.1
    }
}
