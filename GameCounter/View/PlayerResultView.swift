//
//  PlayerResultView.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 11.10.22.
//

import UIKit

class PlayerResultView: UIView {
    
    var placeLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = .white
        
        return label
    }()
    
    var nameLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = Colors.shared.namesColor
        
        return label
    }()
    
    var scoreLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabels(player: PlayerModel, place: Int) {
        self.placeLabel.text = "#\(place + 1) "
        self.nameLabel.text = player.name
        self.scoreLabel.text = "\(player.score)"
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(placeLabel)
        self.addSubview(nameLabel)
        self.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            placeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            placeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: placeLabel.rightAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            scoreLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0)
        ])
    }
}

