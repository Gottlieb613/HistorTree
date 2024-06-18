//
//  Turn.swift
//  GameTest
//
//  Created by Charlie Gottlieb on 6/7/24.
//

import Foundation
import UIKit

enum Turn {
    case Red
    case Yellow
}

var currentTurn = Turn.Yellow

func toggleTurn(_ turnImage: UIImageView) {
    if yellowTurn() {
        currentTurn = Turn.Red
        turnImage.tintColor = .red
    } else {
        currentTurn = Turn.Yellow
        turnImage.tintColor = .yellow
    }
}

func yellowTurn() -> Bool {
    return currentTurn == Turn.Yellow
}

func currentTurnTile() -> Tile {
    return yellowTurn() ? Tile.Yellow : Tile.Red
}

func currentTurnColor() -> UIColor {
    return yellowTurn() ? .yellow : .red
}

func currentTurnVictoryMessage() -> String {
    return yellowTurn() ? "Yellow wins!" : "Red wins!"
}
