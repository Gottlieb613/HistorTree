//
//  Board.swift
//  GameTest
//
//  Created by Charlie Gottlieb on 6/7/24.
//

import Foundation
import UIKit

var board = [[BoardItem]]()

func resetBoard() {
    board.removeAll()
    
    for row in 0...5 {
        var rowArray = [BoardItem]()
        for col in 0...6 {
            let indexPath = IndexPath.init(item: col, section: row)
            let boardItem = BoardItem(indexPath: indexPath, tile: Tile.Empty)
            rowArray.append(boardItem)
        }
        board.append(rowArray)
    }
}

func getBoardItem(_ indexPath: IndexPath) -> BoardItem {
    return board[indexPath.section][indexPath.item]
}

func getLowestEmptyBoardItem(_ col: Int) -> BoardItem? {
    for row in (0...5).reversed() {
        let boardItem = board[row][col]
        if boardItem.emptyTile() {
            return boardItem
        }
    }
    
    return nil
}

func updateBoardWithBoardItem(_ boardItem: BoardItem) {
    if let indexPath = boardItem.indexPath {
        board[indexPath.section][indexPath.item] = boardItem
    }
}

func boardIsFull() -> Bool {
    for row in board {
        for tile in row {
            if tile.emptyTile() {
                return false
            }
        }
    }
    return true
}


func victoryAchieved() -> Bool {
    return horizontalVictory() || verticalVictory() || diagVictory()
}


func horizontalVictory() -> Bool {
    for row in board {
        var consecutive = 0
        for tile in row {
            if tile.tile == currentTurnTile() {
                consecutive += 1
                if consecutive >= 4 {
                    return true
                }
            } else {
                consecutive = 0
            }
        }
    }
    return false
}

func verticalVictory() -> Bool {
    for col in 0...board.count {
        var consecutive = 0
        for row in board {
            if row[col].tile == currentTurnTile() {
                consecutive += 1
                if consecutive >= 4 {
                    return true
                }
            } else {
                consecutive = 0
            }
        }
    }
    
    return false
}

func diagVictory() -> Bool {
    for row in 0...2 {
        for col in 0...3 {
            if checkDiag(startRow: row, startCol: col, right: true) ||
                checkDiag(startRow: row, startCol: board[0].count - 1 - col, right: false) {
                return true
            }
        }
    }
    return false
}

func checkDiag(startRow: Int, startCol: Int, right: Bool) -> Bool {
    let dir = right ? 1 : -1
    let currTile = board[startRow][startCol].tile
    if currTile != Tile.Empty {
        return currTile == board[startRow + 1][startCol + 1*dir].tile &&
               currTile == board[startRow + 2][startCol + 2*dir].tile &&
               currTile == board[startRow + 3][startCol + 3*dir].tile
    }
    return false
}

/*
2,0 -> 2,6,false
 dir=


*/
