//
//  ResultsViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 11.10.22.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var scoreHandler: ScoreHandling
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Results"
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.shared.backgroundForActive
        
        return tableView
    }()
    
    init(scoreHandler: ScoreHandling) {
        self.scoreHandler = scoreHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setBarButtons()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: Setup

private extension ResultsViewController {
    
    func setup() {
        self.view.backgroundColor = Colors.shared.backgroundColor
        self.view.addSubview(titleLabel)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 15
        tableView.allowsSelection = false
        
        let scaleMultiplier = self.view.frame.height / Sizes.canvasHeight
        
        for (index, player) in scoreHandler.results.enumerated() {
            let view = PlayerResultView()
            view.setupLabels(player: player, place: index)
            
            self.stackView.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 41.0 * scaleMultiplier),
            ])
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Sizes.titleHeight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18.0 * scaleMultiplier),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            scrollView.heightAnchor.constraint(equalToConstant: Sizes.scrollViewHeight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20.0 * 2)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Sizes.tableViewTopSpace * scaleMultiplier),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Sizes.tableViewBottomSpace * scaleMultiplier)
        ])
    }
    
    func setBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(resumeButtonPressed(_:)))
    }
}

// MARK: Actions

extension ResultsViewController {
    
    @objc func newGameButtonPressed(_ sender: UIBarButtonItem) {
        let newGameVC = NewGameViewController(scoreHandler: ScoreHandling())
        self.navigationController?.present(UINavigationController(rootViewController: newGameVC), animated: true, completion: nil)
    }
    
    @objc func resumeButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UITableViewDataSource

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scoreHandler.history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let history: [HistoryModel] = scoreHandler.history.reversed()
        
        cell.backgroundColor = Colors.shared.backgroundForActive
        cell.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.textLabel?.text = history[indexPath.row].player.name
        cell.detailTextLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = history[indexPath.row].scoreChange > 0 ? "+\(history[indexPath.row].scoreChange)" : "\(history[indexPath.row].scoreChange)"
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension ResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Sizes.cellHeight
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return viewForHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Sizes.headerHeight
    }
    
    func viewForHeader() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.shared.backgroundForActive
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Turns"
        label.font = UIFont(name: "Nunito-Medium", size: 16.0)
        label.textColor = Colors.shared.darkLabelColor
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
        
        return view
    }
}

extension ResultsViewController {
    enum Sizes {
        static let canvasHeight: CGFloat = 812.0
        static let canvasWidth: CGFloat = 375.0
        
        static let titleHeight: CGFloat = 41.0
        static let scrollViewHeight: CGFloat = 224.0
        static let tableViewTopSpace: CGFloat = 25.0
        static let tableViewBottomSpace: CGFloat = 10.0
        
        static let cellHeight: CGFloat = 55.0
        static let headerHeight: CGFloat = 50.0
    }
}

