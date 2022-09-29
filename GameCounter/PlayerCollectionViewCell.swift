//
//  PlayerCollectionViewCell.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 27.09.22.
//

import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "John"
        label.textColor = Colors.shared.namesColor
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28.0)
        
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Nunito-Bold", size: 100.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.contentView.backgroundColor = Colors.shared.backgroundForActive
        self.contentView.layer.cornerRadius = 15.0
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 23.44)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    
}
