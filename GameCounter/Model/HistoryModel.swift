//
//  HistoryModel.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 14.10.22.
//

import Foundation

class HistoryModel: NSObject, NSCoding {
    
    var player: PlayerModel
    var scoreChange: Int = 0
    
    init(player: PlayerModel, scoreChange: Int) {
        self.player = player
        self.scoreChange = scoreChange
    }
    
    required init?(coder: NSCoder) {
        self.player = coder.decodeObject(forKey: "player") as! PlayerModel
        self.scoreChange = coder.decodeInteger(forKey: "scoreChange")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(player, forKey: "player")
        coder.encode(scoreChange, forKey: "scoreChange")
    }
    
  
}
