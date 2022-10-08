//
//  GameViewController.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 27.09.22.
//

import UIKit

class GameViewController: UIViewController {
    
    var scoreHandler: ScoreHandling
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Game"
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36.0)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let diceButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "miniDice")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private let timerButton: UIButton = {
       let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Pause")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(timerButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private var isRunning: Bool = true
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.shared.backgroundColor
        
        return collectionView
    }()
    
    private let plusOneButton = GameButton()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Previous")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Next")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let scoreButtons: [GameButton] = [GameButton(withTitle: "-10"), GameButton(withTitle: "-5"), GameButton(withTitle: "-1"), GameButton(withTitle: "+5"), GameButton(withTitle: "+10")]
    private let scoreButtonsValues: [Int] = [-10, -5, -1, 5, 10]
    
    private let scoreStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private let undoButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Undo")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private var timer: Timer?
    private var seconds = 0
    
    init(scoreHandler: ScoreHandling) {
        self.scoreHandler = scoreHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setBarButtons()
        
        collectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        
        fireTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        plusOneButton.layer.cornerRadius = plusOneButton.bounds.height / 2
        
        for button in scoreButtons {
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }

}

// MARK: - Setup

private extension GameViewController {
    
    func setupUI() {
        self.view.backgroundColor = Colors.shared.backgroundColor
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(diceButton)
        self.view.addSubview(timerLabel)
        self.view.addSubview(timerButton)
        self.view.addSubview(collectionView)
        self.view.addSubview(plusOneButton)
        self.view.addSubview(previousButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(scoreStackView)
        self.view.addSubview(undoButton)
        
        plusOneButton.setTitle("+1", for: .normal)
        plusOneButton.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 40.0)
        plusOneButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        diceButton.addTarget(self, action: #selector(goToRoll(_:)), for: .touchUpInside)
        plusOneButton.addTarget(self, action: #selector(plusScoreButtonPressed(_:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonPressed(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonPressed(_:)), for: .touchUpInside)
        
        for button in scoreButtons {
            scoreStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(plusScoreButtonPressed(_:)), for: .touchUpInside)
        }
        
        let scaleMultiplier = self.view.frame.height / Sizes.canvasHeight

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Sizes.titleHeight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            diceButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            diceButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            diceButton.heightAnchor.constraint(equalToConstant: Sizes.diceSideSize * scaleMultiplier),
            diceButton.widthAnchor.constraint(equalTo: diceButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Sizes.timerLabelTopSpace * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            timerButton.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: Sizes.timeButtonLeadingSpace),
            timerButton.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: Sizes.collectionViewTopSpace * scaleMultiplier),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Sizes.colletionViewHeight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            plusOneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            plusOneButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Sizes.plusOneButtonTopSpace),
            plusOneButton.heightAnchor.constraint(equalToConstant: Sizes.plusOneButtonSide * scaleMultiplier),
            plusOneButton.widthAnchor.constraint(equalTo: plusOneButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Sizes.previousButtonLeadingSpace),
            previousButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Sizes.nextButtonTrailingSpace),
            nextButton.centerYAnchor.constraint(equalTo: plusOneButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scoreStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            scoreStackView.topAnchor.constraint(equalTo: plusOneButton.bottomAnchor, constant: Sizes.stackViewTopSpace * scaleMultiplier),
            scoreStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            scoreStackView.heightAnchor.constraint(equalToConstant: Sizes.stackViewHeight * scaleMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            undoButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40.0),
            undoButton.topAnchor.constraint(equalTo: scoreStackView.bottomAnchor, constant: Sizes.undoButtonTopSpace * scaleMultiplier),
            undoButton.heightAnchor.constraint(equalToConstant: Sizes.undoButtonHeight * scaleMultiplier),
            undoButton.widthAnchor.constraint(equalToConstant: Sizes.undoButtonWidth * scaleMultiplier)
        ])
        
    }
    
    func setBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(resultsButtonPressed(_:)))
    }
}

// MARK: Action Methods

extension GameViewController {
    
    @objc func newGameButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func resultsButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func goToRoll(_ sender: UIButton) {
        let diceVC = DiceViewController()
        diceVC.modalPresentationStyle = .overCurrentContext
        diceVC.modalTransitionStyle = .crossDissolve
        self.present(diceVC, animated: true, completion: nil)
    }
    
    @objc func timerButtonPressed(_ sender: UIButton) {
        isRunning.toggle()
        
        if (isRunning) {
            timerButton.setImage(UIImage(named: "Pause"), for: .normal)
            timerLabel.alpha = 1.0
            fireTimer()
        } else {
            timerButton.setImage(UIImage(named: "Play"), for: .normal)
            timerLabel.alpha = 0.4
            timer?.invalidate()
        }
    }
    
    @objc func plusScoreButtonPressed(_ sender: GameButton) {
        if (sender == plusOneButton) {
            plusScore(score: 1)
        }
        
        for (index, button) in scoreButtons.enumerated() {
            if sender == button {
                plusScore(score: scoreButtonsValues[index])
            }
        }
    }

    func plusScore(score: Int) {
        scoreHandler.currentPlayer.score += score
        collectionView.reloadItems(at: [IndexPath(row: scoreHandler.index, section: 0)])
        if (scoreHandler.index != scoreHandler.players.count - 1 ) {
            scoreHandler.index += 1
        } else if (self.scoreHandler.index + 1 >= scoreHandler.players.count - 1) {
            scoreHandler.index = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            collectionView.scrollToItem(at: IndexPath(row: scoreHandler.index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func previousButtonPressed(_ sender: UIButton) {
        if (scoreHandler.index != 0) {
            scoreHandler.index -= 1
            collectionView.scrollToItem(at: IndexPath(row: scoreHandler.index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        if (scoreHandler.index != scoreHandler.players.count - 1) {
            scoreHandler.index += 1
            collectionView.scrollToItem(at: IndexPath(row: scoreHandler.index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func undoButtonPressed(_ sender: UIButton) {
     //FIXME: HISTORY
    }
}

// MARK: - Timer Action

private extension GameViewController {
    
    func fireTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerLabel() {
        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes,seconds)
    }
    
}

// MARK: - CollectionViewDelegate

extension GameViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)  {

        let pageWidth = (Sizes.collectionViewCellWidth + Sizes.lineSpacing) * (Sizes.canvasWidth / UIScreen.main.bounds.width)
        let itemIndex = (targetContentOffset.pointee.x) / pageWidth
        print(velocity.x)
        //FIXME: WIDER DEVIDER
        if (velocity.x == 0) {
            targetContentOffset.pointee = CGPoint(x: round(itemIndex) * pageWidth, y: targetContentOffset.pointee.y)
            print(round(itemIndex) * pageWidth)
        } else if (velocity.x > 0) {
            if (scoreHandler.index != scoreHandler.players.count - 1) {
                scoreHandler.index += 1
                targetContentOffset.pointee = CGPoint(x: CGFloat(scoreHandler.index) * pageWidth, y: targetContentOffset.pointee.y)
            }
        } else {
            if (scoreHandler.index != 0) {
                scoreHandler.index -= 1
                targetContentOffset.pointee = CGPoint(x: CGFloat(scoreHandler.index) * pageWidth, y: targetContentOffset.pointee.y)
            }
        }
        print(scoreHandler.index)
     
    }

}

// MARK: - CollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scoreHandler.players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCollectionViewCell.identifier, for: indexPath)
        
        if let cell = cell as? PlayerCollectionViewCell {
            cell.setNameAndScore(name: scoreHandler.players[indexPath.row].name, score: scoreHandler.players[indexPath.row].score)
        }
        return cell
    }

}

// MARK: - CollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Sizes.collectionViewCellHeight * UIScreen.main.bounds.height / Sizes.canvasHeight
        let width = Sizes.collectionViewCellWidth * UIScreen.main.bounds.width / Sizes.canvasWidth
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Sizes.lineSpacing * UIScreen.main.bounds.width / Sizes.canvasWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)).width
        let sideInset = (view.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}

extension GameViewController {
    enum Sizes {
        static let canvasHeight: CGFloat = 812.0
        static let canvasWidth: CGFloat = 375.0
        
        static let titleHeight: CGFloat = 41.0
        static let diceSideSize: CGFloat = 30.0
        
        static let timerLabelHeight: CGFloat = 41.0
        static let timerLabelTopSpace: CGFloat = 29.0
        
        static let timeButtonLeadingSpace: CGFloat = 20.0
        
        static let collectionViewTopSpace: CGFloat = 42.0
        static let colletionViewHeight: CGFloat = 305.0
        
        static let collectionViewCellHeight: CGFloat = 300.0
        static let collectionViewCellWidth: CGFloat = 255.0
        static let lineSpacing: CGFloat = 20.0
        
        static let plusOneButtonTopSpace: CGFloat = 28.0
        static let plusOneButtonSide: CGFloat = 90.0
        
        static let previousButtonLeadingSpace: CGFloat = 46.0
        static let nextButtonTrailingSpace: CGFloat = 50.0
        
        static let stackViewTopSpace: CGFloat = 22.0
        static let stackViewHeight: CGFloat = 55.0
        
        static let undoButtonLeadingSpace: CGFloat = 40.0
        static let undoButtonTopSpace: CGFloat = 23.0
        static let undoButtonHeight: CGFloat = 20.0
        static let undoButtonWidth: CGFloat = 15.0
    }
}
