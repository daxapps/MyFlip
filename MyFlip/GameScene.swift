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
    
    var board: Board!
    
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
        
        board = Board()
        
        // 1: set up the constants for positioning
        
        let offsetX = -280
        let offsetY = -281
        let stoneSize = 80
        
        for row in 0 ..< Board.size {
            
            // 2: count from 0 to 7, creating a new array of stones
            
            var colArray = [Stone]()
            for col in 0 ..< Board.size {
                
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
            
            board.rows.append([StoneColor](repeating: .empty, count: Board.size))
            
            // 7: add each column to the rows array
            
            rows.append(colArray)
        
        }
        
        rows[4][3].setPlayer(.white)
        rows[4][4].setPlayer(.black)
        rows[3][4].setPlayer(.white)
        rows[3][3].setPlayer(.black)
        
        board.rows[4][3] = .white
        board.rows[4][4] = .black
        board.rows[3][4] = .white
        board.rows[3][3] = .black
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1: unwrap the first touch
        guard let touch = touches.first else { return }
        
        // 2: find the game board, or return if it somehow couldn't be found
        guard let gameBoard = childNode(withName: "board") else { return }
        
        // 3: figure out where on the game board the touch landed.
        let location = touch.location(in: gameBoard)
        
        // 4: pull out an array of all nodes at that location
        let nodesAtPoint = nodes(at: location)
        
        // 5: filter out all nodes that aren't stones
        let tappedStones = nodesAtPoint.filter { $0 is Stone }
        
        // 6: if no stone was tapped, bail out
        guard tappedStones.count > 0 else { return }
        let tappedStone = tappedStones[0] as! Stone
        
        // 7: pass the tapped stone's row and column into our new canMoveIn() method
        if board.canMoveIn(row: tappedStone.row, col: tappedStone.col) {
            
            // 8: print a message if the move is legal
            //print("Move is legal")
            
            makeMove(row: tappedStone.row, col: tappedStone.col)
            
//            if board.currentPlayer.stoneColor == .white {
//                makeAIMove()
//            }
            
        } else {
            
            print("Move is illegal")
        }
    }
    
    func makeMove(row: Int, col: Int) {
        
        // find the list of captured stones
        let captured = board.makeMove(player: board.currentPlayer, row: row, col: col)
        
        for move in captured {
            
            // pull out the sprite for each captured stone
            let stone = rows[move.row][move.col]
            
            // update who owns it
            stone.setPlayer(board.currentPlayer.stoneColor)
            
            // make it 120% of its normal size
            stone.xScale = 1.2
            stone.yScale = 1.2
            
            // animate it down to 100%
            stone.run(SKAction.scale(to: 1, duration: 0.5))
        }
        
        // change players
        board.currentPlayer = board.currentPlayer.opponent
    }
    
}
