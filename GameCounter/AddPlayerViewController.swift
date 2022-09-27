//
//  AddPlayerViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 24.09.22.
//

import UIKit

protocol AddPlayerViewControllerDelegate: AnyObject {
    func didAddPlayer(name: String)
}

class AddPlayerViewController: UIViewController {
    
    weak var delegate: AddPlayerViewControllerDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Add Player"
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
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
        setBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nameTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        nameTextField.resignFirstResponder()
    }

}

// MARK: - Setup

private extension AddPlayerViewController {
    
    func setupUI() {
        self.view.backgroundColor = Colors.shared.backgroundColor
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 25.0),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 60.0)
            //FIXME: TO CONSTANTS
        ])
        
    }
}

// MARK: Action Methods

private extension AddPlayerViewController {
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showEmptyNameAlert()
            return
        }
        delegate?.didAddPlayer(name: name)
    }
    
    func showEmptyNameAlert() {
        let alert = UIAlertController(title: "Error", message: "Player's name is empty. Please fill in the field.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: .none)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonPressed(_:)))
    }
}
