//
//  Turn.swift
//  GameTest
//
//  Created by Charlie Gottlieb on 6/7/24.
//

import Foundation
import UIKit

enum Turn {
    case Player0
    case Player1
}

var currentTurn = Turn.Player0

func toggleTurn(_ turnImage: UIImageView) {
    if p0Turn() {
        currentTurn = Turn.Player1
        turnImage.tintColor = .black
    } else {
        currentTurn = Turn.Player0
        turnImage.tintColor = .systemBlue
    }
}

func p0Turn() -> Bool {
    return currentTurn == Turn.Player0
}

func currentTurnTile() -> Tile {
    return p0Turn() ? Tile.Player0 : Tile.Player1
}

func currentTurnColor() -> UIColor {
    return p0Turn() ? .systemBlue : .black
}

func currentTurnVictoryMessage() -> String {
    return p0Turn() ? "Player 0 wins!" : "Player 1 wins!"
}
