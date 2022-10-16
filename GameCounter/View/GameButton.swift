//
//  GameButton.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import UIKit

class GameButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withTitle title: String) {
        super.init(frame: .zero)
        setup()
        self.setTitle(title, for: .normal)
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Colors.shared.buttonColor
        
        self.layer.shadowColor = UIColor.init(red: 0.33, green: 0.47, blue: 0.44, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.cornerRadius = 35
        
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.titleLabel?.layer.shadowColor = UIColor.init(red: 0.33, green: 0.47, blue: 0.44, alpha: 1.0).cgColor
        self.titleLabel?.layer.shadowOpacity = 1
        self.titleLabel?.layer.shadowRadius = 0
        
        self.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 24)
        self.setTitle("Start Game", for: .normal)
        
        
        //FIXME: PRESS EFFECT
    }
}
