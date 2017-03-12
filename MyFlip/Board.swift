//
//  Board.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit

class Board: NSObject {

    var currentplayer = Player.allPlayers[0]
    
    static let size = 8    
    var rows = [[StoneColor]]()
    
}
