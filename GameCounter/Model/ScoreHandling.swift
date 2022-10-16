//
//  File.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 6.10.22.
//

import Foundation

class ScoreHandling: NSObject, NSCoding {
    
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
    
    var history: [HistoryModel] = []
    
    override init() {}
    
    required init?(coder: NSCoder) {
        self.players = coder.decodeObject(forKey: "players") as! [PlayerModel]
        self.index = coder.decodeInteger(forKey: "index")
        self.history = coder.decodeObject(forKey: "history") as! [HistoryModel]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(players, forKey: "players")
        coder.encode(index, forKey: "index")
        coder.encode(history, forKey: "history")
    }
    
    static func load() -> ScoreHandling? {
        if let data = UserDefaults.standard.object(forKey: "gameData") {
            guard let scoreHandler = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) else {
                return nil
            }
            return scoreHandler as? ScoreHandling
        } else {
            return nil
        }
    }
    

}
