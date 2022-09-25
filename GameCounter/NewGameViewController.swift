//
//  NewGameViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 23.09.22.
//

import UIKit

class NewGameViewController: UIViewController {
    
    var players: [PlayerModel] = [PlayerModel(name: "Felix"), PlayerModel(name: "Jesse")]
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        tableView.backgroundColor = Colors.shared.backgroundForActive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var startGameButton = GameButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        var frame = tableView.frame
//        frame.size.height = tableView.contentSize.height
//         tableView.frame = frame
//
//        tableView.reloadData()
//        tableView.layoutIfNeeded()
//        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true

    }

}

// MARK: - Setup
// FIXME: TO CONSTANTS
private extension NewGameViewController {
    
    func setupUI() {
        self.view.backgroundColor = Colors.shared.backgroundColor
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Game Counter"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                             NSAttributedString.Key.font : UIFont.init(name: "Nunito-ExtraBold", size: 36.0)!]
    }
    
    func setupTableView() {
        self.tableView.layer.cornerRadius = 15.0
        self.tableView.separatorColor = Colors.shared.separatorColor
        self.tableView.allowsSelection = false
        
        self.view.addSubview(tableView)
        self.view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25.0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            tableView.heightAnchor.constraint(equalToConstant: 50.0 + 55.0*6)
        ])
        
        NSLayoutConstraint.activate([
            startGameButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            startGameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            startGameButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -65.0),
            startGameButton.heightAnchor.constraint(equalToConstant: 65.0)
        ])
    }
}

// MARK: - UITableViewDataSource

extension NewGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        
        if (indexPath.row != players.count) {
            cell.switchToDeleteType()
            cell.textLabel?.text = players[indexPath.row].name
            cell.iconAction = deleteIconTapped(_:)
        } else {
            cell.switchToAddType()
            cell.iconAction = addIconTapped(_:)
        }
        return cell
    }
    
}

// MARK: - Action Methods

private extension NewGameViewController {
    
    func addIconTapped(_ sender: UIImageView) {
        let addPlayerVC = AddPlayerViewController()
        addPlayerVC.delegate = self
        self.navigationController?.pushViewController(addPlayerVC, animated: true)
    }
    
    func deleteIconTapped(_ sender: UIImageView) {
        let point = sender.convert(sender.center, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        players.remove(at: indexPath.row)
        self.tableView.performBatchUpdates({
            self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .top)
        }, completion: nil)
        
    }
}

// MARK: - UITableViewDelegate

extension NewGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return viewForHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func viewForHeader() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.shared.backgroundForActive
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Players"
        label.font = UIFont(name: "Nunito-Medium", size: 16.0)
        label.textColor = Colors.shared.darkLabelColor
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
        
        return view
    }
}


// MARK: - AddPlayerViewControllerDelegate

extension NewGameViewController: AddPlayerViewControllerDelegate {
    
    func didAddPlayer(name: String) {
        players.append(PlayerModel(name: name))
        navigationController?.popViewController(animated: true)
    }
    
}
