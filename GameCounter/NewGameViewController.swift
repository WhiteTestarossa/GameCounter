//
//  NewGameViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 23.09.22.
//

import UIKit

class NewGameViewController: UIViewController {
    
    var players: [PlayerModel] = []
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Game Counter"
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = Colors.shared.backgroundForActive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var startGameButton = GameButton()
    
    private var heightConstraint: NSLayoutConstraint!
    
    private var sizesDidCalculated: Bool = false
    private var cellsNumber: Int!
    private var scaleMultiplier: CGFloat = UIScreen.main.bounds.height / Sizes.canvasHeight
    private var maxHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if (!sizesDidCalculated) {
            let freeSpace = self.view.safeAreaLayoutGuide.layoutFrame.height - (Sizes.occupiedHeight + Sizes.tableViewBottomSpace) * scaleMultiplier
            self.cellsNumber = Int((freeSpace - Sizes.headerAndFooterHeight * scaleMultiplier) / (Sizes.cellHeight * scaleMultiplier))
            self.maxHeight = (Sizes.headerAndFooterHeight + Sizes.cellHeight * CGFloat(cellsNumber)) * scaleMultiplier
            sizesDidCalculated = true
        }
    }

}

// MARK: - Setup

private extension NewGameViewController {
    
    func setupUI() {
        
        self.view.backgroundColor = Colors.shared.backgroundColor
        
        self.tableView.layer.cornerRadius = 15.0
        self.tableView.separatorColor = Colors.shared.separatorColor
        self.tableView.allowsSelection = false
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(startGameButton)
        
        self.heightConstraint = tableView.heightAnchor.constraint(equalToConstant: Sizes.tableViewInitialHeight * scaleMultiplier)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Sizes.titleHight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Sizes.tableViewTopConstraintConst * scaleMultiplier),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            heightConstraint
        ])
        
        NSLayoutConstraint.activate([
            startGameButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            startGameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            startGameButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Sizes.startButtonBottomConstaintConst * scaleMultiplier),
            startGameButton.heightAnchor.constraint(equalToConstant: Sizes.startButtonHeight * scaleMultiplier)
        ])

    }
}

// MARK: - UITableViewDataSource

extension NewGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        
        cell.switchToDeleteType()
        cell.textLabel?.text = players[indexPath.row].name
        cell.iconAction = deleteIconTapped(_:)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        
        return cell
    }
    
}

// MARK: - Action Methods

private extension NewGameViewController {
    
    @objc func addIconTapped(_ sender: UIImageView) {
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
        }, completion: {_ in
    
        })

        if (players.count < cellsNumber) {
            self.heightConstraint.constant -= Sizes.cellHeight * scaleMultiplier
        }
        
    }
}

// MARK: - UITableViewDelegate

extension NewGameViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.cellHeight * scaleMultiplier
    }
    
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return viewForHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Sizes.tableViewHeaderHeight * scaleMultiplier
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
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
        
        return view
    }
    
    // MARK: Footer
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooter()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Sizes.tableViewFooterHeight * scaleMultiplier
    }
    
    func viewForFooter() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.shared.backgroundForActive
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = Colors.shared.buttonColor
        label.text = "Add player"
        
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "Add"), for: .normal)
        addButton.addTarget(self, action: #selector(addIconTapped(_:)), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(addButton)
        
        let insets = tableView.separatorInset
        let width = tableView.bounds.width - insets.left - insets.right
        let sepFrame = CGRect(x: 20.0, y: 0, width: width, height: 0.5)
        
        let sep = CALayer()
        sep.frame = sepFrame
        sep.backgroundColor = tableView.separatorColor?.cgColor
        
        view.layer.addSublayer(sep)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14.0),
            label.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 15.0),
            label.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
        
        return view
    }

}


// MARK: - AddPlayerViewControllerDelegate

extension NewGameViewController: AddPlayerViewControllerDelegate {
    
    func didAddPlayer(name: String) {
        players.append(PlayerModel(name: name))

        if (tableView.frame.height + Sizes.cellHeight * scaleMultiplier < maxHeight) {
            heightConstraint.constant += Sizes.cellHeight * scaleMultiplier
        } else {
            heightConstraint.constant = maxHeight
        }
      
        navigationController?.popViewController(animated: true)
    }
    
}

private extension NewGameViewController {
    enum Sizes {
        static let canvasHeight: CGFloat = 812.0
        
        static let titleHight: CGFloat = 41.0
        static let startButtonHeight: CGFloat = 65.0
        
        static let tableViewHeaderHeight: CGFloat = 46.0
        static let tableViewInitialHeight: CGFloat = tableViewHeaderHeight + tableViewFooterHeight
        static let tableViewFooterHeight: CGFloat = 59.0
        static let cellHeight: CGFloat = 55.0
        static let headerAndFooterHeight = tableViewHeaderHeight + tableViewFooterHeight
        
        static let occupiedHeight: CGFloat = titleHight + tableViewTopConstraintConst + startButtonHeight + startButtonBottomConstaintConst + tableViewBottomSpace
        
        static let tableViewTopConstraintConst: CGFloat = 25.0
        static let tableViewBottomSpace: CGFloat = 25.0
        static let startButtonBottomConstaintConst: CGFloat = 65.0
    }
}
