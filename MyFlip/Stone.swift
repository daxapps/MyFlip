//
//  Stone.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import SpriteKit

class Stone: SKSpriteNode {

    // 1: create shared properties for the three possible textures stones can have
    
    static let thinkingTexture = SKTexture(imageNamed: "thinking")
    static let whiteTexture = SKTexture(imageNamed: "white")
    static let blackTexture = SKTexture(imageNamed: "black")
    
    // 2: a method that will set the stone's texture to match the player's color
    
    func setPlayer(_ player: StoneColor) {
        
        if player == .white {
            
            texture = Stone.whiteTexture
            
        } else if player == .black {
            
            texture = Stone.blackTexture
            
        } else if player == .choice {
            
            texture = Stone.thinkingTexture
        }
    }
    
    // 3: the row and column this stone belongs to
    
    var row = 0
    var col = 0
}
