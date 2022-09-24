//
//  PlayerNameTextField.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import UIKit

class PlayerNameTextField: UITextField {
    
    private let insets: UIEdgeInsets = UIEdgeInsets(top: 18.0, left: 24.0, bottom: 18.0, right: 10.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

}
