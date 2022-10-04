//
//  DiceViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 4.10.22.
//

import UIKit

class DiceViewController: UIViewController {
    
    private let dice: [UIImage] = [
        UIImage(name: "dice_1"),
        UIImage(name: "dice_2"),
        UIImage(name: "dice_3"),
        UIImage(name: "dice_4"),
        UIImage(name: "dice_5"),
        UIImage(name: "dice_6"),
    ]
    
    private let diceImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideDiceVC))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

}

private extension DiceViewController {
    
    func setup() {
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        diceImage.translatesAutoresizingMaskIntoConstraints = false
        diceImage.image = showRandomDiceNumber(dice: dice)
        
        let scaleMultiplier = UIScreen.main.bounds.height / 812.0
        
        self.view.addSubview(blurEffectView)
        self.view.addSubview(diceImage)
        
        NSLayoutConstraint.activate([
            diceImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            diceImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            diceImage.heightAnchor.constraint(equalToConstant: 120.0 * scaleMultiplier),
            diceImage.widthAnchor.constraint(equalTo: diceImage.heightAnchor)
        ])
    }
    
    func showRandomDiceNumber(dice: [UIImage]) -> UIImage {
        var numberImage = UIImage()
        
        if let number = dice.randomElement() {
            numberImage = number
        }
        
        return numberImage
    }
    
    @objc func hideDiceVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    
    convenience init(name: String) {
        self.init(named: name)!
    }
}

