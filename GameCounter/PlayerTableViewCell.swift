//
//  PlayerTableViewCell.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 23.09.22.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    static let identifier = "PlayerCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.backgroundColor = Colors.shared.backgroundForActive
        self.imageView?.image = UIImage(named: "Delete")
        self.textLabel?.text = "Felix"
        self.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        self.textLabel?.textColor = UIColor.white
    }
    
    func switchToAddType() {
        self.imageView?.image = UIImage(named: "Add")
        self.textLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        self.textLabel?.textColor = Colors.shared.buttonColor
        self.textLabel?.text = "Add player"
    }
    
}
