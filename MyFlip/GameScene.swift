//
//  GameScene.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var rows = [[Stone]]()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        
        background.blendMode = .replace
        background.zPosition = 1
        addChild(background)
        
        let gameBoard = SKSpriteNode(imageNamed: "board")
        
        gameBoard.name = "board"
        gameBoard.zPosition = 2
        addChild(gameBoard)
        
        //board = Board()
        
        // 1: set up the constants for positioning
        
        let offsetX = -280
        let offsetY = -281
        let stoneSize = 80
        
        for row in 0 ..< 8 {
            
            // 2: count from 0 to 7, creating a new array of stones
            
            var colArray = [Stone]()
            for col in 0 ..< 8 {
                
                // 3: create from 0 to 7, creating a new stone object
                
                let stone = Stone(color: UIColor.clear, size: CGSize(width: stoneSize, height: stoneSize))
                
                // 4: place the stone at the correct position
                
                stone.position = CGPoint(x: offsetX + (col * stoneSize), y: offsetY + (row * stoneSize))
                
                // 5: tell the stone its row and column
                
                stone.row = row
                stone.col = col
                
                // 6: add each stone to the game board and the column array
                
                gameBoard.addChild(stone)
                
                colArray.append(stone)
            }
            
//            board.rows.append([StoneColor](repeating: .empty, count: Board.size))
            
            // 7: add each column to the rows array
            
            rows.append(colArray)
        
        }
        
        rows[4][3].setPlayer(.white)
        rows[4][4].setPlayer(.black)
        rows[3][4].setPlayer(.white)
        rows[3][3].setPlayer(.black)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
