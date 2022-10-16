//
//  PlayerModel.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import Foundation

class PlayerModel: NSObject, NSCoding {
    
    var name: String = "Felix"
    var score: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.score = coder.decodeInteger(forKey: "score")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(score, forKey: "score")
    }
    
 
    
}
