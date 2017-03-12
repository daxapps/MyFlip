//
//  Board.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit

class Board: NSObject {
    
    static let size = 8
    
    static let moves = [Move(row: -1, col: -1), Move(row: 0, col: -1), Move(row: 1, col: -1), Move(row: -1, col: 0),Move(row: 1, col: 0), Move(row: -1, col: 1), Move(row: 0, col: 1), Move(row: 1, col: 1)]
    
    var currentPlayer = Player.allPlayers[0]
    
    var rows = [[StoneColor]]()
    
    func canMoveIn(row: Int, col: Int) -> Bool {
        
        // test 1: check move is sensible
        if !isInBounds(row: row, col: col) { return false }
        
        // test 2: check move hasn't been made already
        let stone = rows[row][col]
        if stone != .empty { return false }
        
        // test 3: check the move is legal
        
        // 1. loop through each possible move
        for move in Board.moves {
            
            // 2. create a variable to track whether we've passed at least one opponent stone
            var passedOpponent = false
            
            // 3: set movement variables containing our initial row andvcolumn
            var currentRow = row
            var currentCol = col
            
            // 4: count from here up to the edge of the board, applying our move each time
            for _ in 0 ..< Board.size {
                
                // 5: add the move to our movement variables
                currentRow += move.row
                currentCol += move.col
                
                // 6: if our new position is off the board, break out of the loop
                guard isInBounds(row: currentRow, col: currentCol) else { break }
                let stone = rows[currentRow][currentCol]
                if (stone == currentPlayer.opponent.stoneColor) {
                    
                    // 7: we found an enemy stone
                    passedOpponent = true
                    
                } else if stone == currentPlayer.stoneColor && passedOpponent {
                    // 8: we found one of our stones after finding an enemy stone
                    
                    return true
                } else {
                    // 9: we found something else; bail out
                    break
                }
            }
        }
        // 10: if we're still here it means we failed
        return false
    }
    
    func isInBounds(row: Int, col: Int) -> Bool {
        if row < 0 { return false }
        if col < 0 { return false }
        if row >= Board.size { return false }
        if col >= Board.size { return false }
        return true
    }
}
