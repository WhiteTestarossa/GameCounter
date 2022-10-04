//
//  PlayerModel.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import Foundation

struct PlayerModel {
    
    var name: String = "Felix"
    var score: Int = 0
    
    init(name: String) {
        self.name = name
    }
}
