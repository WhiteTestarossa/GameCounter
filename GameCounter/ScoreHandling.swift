//
//  File.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 6.10.22.
//

import Foundation

class ScoreHandling {
    
    var players: [PlayerModel] = []
    var index = 0
    var currentPlayer: PlayerModel {
        get {
            players[index]
        }
        set {
            players[index] = newValue
        }
    }
    
    var results: [PlayerModel] {
        get {
            players.sorted(by: {$0.score > $1.score})
        }
    }
    
    var history: [(PlayerModel, Int)] = []

}
