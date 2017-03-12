//
//  Player.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit

class Player: NSObject {
    
    var playerId: Int
    
    //create two players, black and white, and store them in a static array
    static let allPlayers = [Player(stone: .black), Player(stone: .white)]
    
    //a property to store this player's color
    var stoneColor: StoneColor
    
    init (stone: StoneColor) {
        stoneColor = stone
        self.playerId = stone.rawValue
    }
    
    //a computed property to return the player's opponent
    var opponent: Player {
        
        if stoneColor == .black {
            
            return Player.allPlayers[1]
            
        } else {
            return Player.allPlayers[0]
        }
    }
}
