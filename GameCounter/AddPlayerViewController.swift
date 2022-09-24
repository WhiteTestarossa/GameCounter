//
//  AddPlayerViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import UIKit

class AddPlayerViewController: UIViewController {
    
    private let nameTextField: PlayerNameTextField = {
        let textfield = PlayerNameTextField()
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = Colors.shared.backgroundForActive
        textfield.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        textfield.textColor = UIColor.lightGray
        textfield.tintColor = UIColor.white
        textfield.autocapitalizationType = .none
        textfield.placeholder = "Player Name"
        
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTextField()
        setBarButtons()
    }

}

// MARK: - Setup

private extension AddPlayerViewController {
    
    func setupUI() {
        self.view.backgroundColor = Colors.shared.backgroundColor
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Add Player"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                             NSAttributedString.Key.font : UIFont.init(name: "Nunito-ExtraBold", size: 36.0)!]
    }
    
    func setupTextField() {
        self.view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25.0),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 60.0)
            //FIXME: TO CONSTANTS
        ])
    }
    
    func setBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(backButtonPressed(_:)))
    }
    
    @objc private func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}