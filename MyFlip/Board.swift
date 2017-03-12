//
//  Board.swift
//  MyFlip
//
//  Created by Jason Crawford on 3/12/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import GameplayKit

class Board: NSObject, GKGameModel {
    
    static let size = 8
    
    static let moves = [Move(row: -1, col: -1), Move(row: 0, col: -1), Move(row: 1, col: -1), Move(row: -1, col: 0),Move(row: 1, col: 0), Move(row: -1, col: 1), Move(row: 0, col: 1), Move(row: 1, col: 1)]
    
    var currentPlayer = Player.allPlayers[0]
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
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
    
    func makeMove(player: Player, row: Int, col: Int) -> [Move] {
        // 1: create an array to hold all captured stones
        var didCapture = [Move]()
        
        // 2: place a stone in the requested position
        rows[row][col] = player.stoneColor
        didCapture.append(Move(row: row, col: col))
        
        for move in Board.moves {
            
            // 3: look in this direction for captured stones
            var mightCapture = [Move]()
            var currentRow = row
            var currentCol = col
            
            // 4: count from here up to the edge of the board, applying our move each time
            for _ in 0 ..< Board.size {
                currentRow += move.row
                currentCol += move.col
                
                // 5: make sure this is a sensible position to move to
                guard isInBounds(row: currentRow, col: currentCol)
                    else { break }
                let stone = rows[currentRow][currentCol]
                if stone == player.opponent.stoneColor {
                    
                    // 6: we found an enemy stone – add it to the list of possible captures
                    mightCapture.append(Move(row: currentRow, col:
                        currentCol))
                } else if stone == player.stoneColor {
                    
                    // 7: we found one of our stones - add the mightCapture array to didCapture
                    didCapture.append(contentsOf: mightCapture)
                    
                    // 8: change all stones to the player's color, then exit the loop because we're finished in this direction
                    mightCapture.forEach {
                        rows[$0.row][$0.col] = player.stoneColor
                    }
                    break } else {
                    
                    // 9: we found something else; bail out
                    break
                }
            }
        }
        
        // 10: send back the list of captured stones
        return didCapture
    }
    
    func getScores() -> (black: Int, white: Int) {
        
        var black = 0
        var white = 0
        
        rows.forEach {
            
            $0.forEach {
                
                if $0 == .black {
                    black += 1
                    
                } else if $0 == .white {
                    white += 1
                }
            }
        }
        return (black, white)
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        
        guard let playerObject = player as? Player else { return false }
        
        let scores = getScores()
        
        if playerObject.stoneColor == .black {
            
            return scores.black > scores.white + 10
            
        } else {
            return scores.white > scores.black + 10
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        // safely unwrap the player object
        guard let playerObject = player as? Player else { return nil }
        
        // if the game is over exit now
        if isWin(for: playerObject) || isWin(for: playerObject.opponent) { return nil }
        
        // if we're still here prepare to send back a list of moves
        var moves = [Move]()
        
        // try every column in every row
        for row in 0 ..< Board.size {
            for col in 0 ..< Board.size {
                
                if canMoveIn(row: row, col: col) {
                    
                    // this move is possible; add it to the list
                    moves.append(Move(row: row, col: col))
                }
            }
        }
        return moves
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        
        guard let move = gameModelUpdate as? Move else { return }
        
        _ = makeMove(player: currentPlayer, row: move.row, col: move.col)
        
        currentPlayer = currentPlayer.opponent
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        
        guard let board = gameModel as? Board else { return }
        
        currentPlayer = board.currentPlayer
        rows = board.rows
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
}
