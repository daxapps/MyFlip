//
//  Move.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    var row: Int
    var col: Int
    
    var value = 0
    
    init (row: Int, col: Int) {
        
        self.row = row
        self.col = col
    }
    
}
