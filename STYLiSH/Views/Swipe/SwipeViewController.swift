//
//  SwipeViewController.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Shuffle_iOS
import Kingfisher

class SwipeViewController: UIViewController {
    
    private let cardStack = SwipeCardStack()
    
    private let buttonStackView = ButtonStackView()
    
    private let featureProvider = FeatureProvider()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "您喜歡哪一種\n風格？"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.hexStringToUIColor(hex: "E94057")
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var modalView: UIView = {
        let modalView = UIView()
        modalView.backgroundColor = UIColor.hexStringToUIColor(hex: "3F3A3A").withAlphaComponent(0.7)
        modalView.frame = view.bounds
        modalView.isHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        modalView.addGestureRecognizer(tapGesture)
        
        return modalView
    }()
    
    private var cardModels: [TinderCardModel] = [
        TinderCardModel(image: UIImage(named: "1")),
        TinderCardModel(image: UIImage(named: "2")),
        TinderCardModel(image: UIImage(named: "3")),
        TinderCardModel(image: UIImage(named: "4"))
    ]
    
    private var styleACount: Int = 0
    
    private var styleBCount: Int = 0
    
    private var styleCCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardStack.delegate = self
        cardStack.dataSource = self
        buttonStackView.delegate = self
        
        configureNavigationBar()
        layoutQuestionLabel()
        layoutCardStackView()
        layoutButtonStackView()
        configureBackgroundGradient()
        layoutModalView()
        
//        getProductTinder()
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back",
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleShift))
        backButton.tag = 1
        backButton.tintColor = .lightGray
        navigationItem.leftBarButtonItem = backButton
        
        let forwardButton = UIBarButtonItem(title: "Forward",
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleShift))
        forwardButton.tag = 2
        forwardButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = forwardButton
        
        navigationController?.navigationBar.layer.zPosition = -1
    }
    
    private func configureBackgroundGradient() {
        let backgroundGray = UIColor(red: 244 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func layoutQuestionLabel() {
        view.addSubview(questionLabel)
        questionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.safeAreaLayoutGuide.leftAnchor,
                             right: view.safeAreaLayoutGuide.rightAnchor,
                             height: 125)
    }
    
    private func layoutButtonStackView() {
        view.addSubview(buttonStackView)
        buttonStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.safeAreaLayoutGuide.rightAnchor,
                               paddingLeft: 80,
                               paddingBottom: 20,
                               paddingRight: 80)
    }
    
    private func layoutCardStackView() {
        view.addSubview(cardStack)
        cardStack.anchor(top: questionLabel.bottomAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor,
                         height: 540)
    }
    
    private func layoutModalView() {
        
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        let leftArrowImageView = UIImageView(image: UIImage(named: "icons8-arrow-48_left"))
        let rightArrowImageView = UIImageView(image: UIImage(named: "icons8-arrow-48_right"))
        let likeButtonImageView = UIImageView(image: UIImage(named: "heart"))
        let passButtonImageView = UIImageView(image: UIImage(named: "pass"))
        
        modalView.addSubview(closeButton)
        modalView.addSubview(leftArrowImageView)
        modalView.addSubview(rightArrowImageView)
        modalView.addSubview(likeButtonImageView)
        modalView.addSubview(passButtonImageView)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 60).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        leftArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        passButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftArrowImageView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            leftArrowImageView.trailingAnchor.constraint(equalTo: modalView.centerXAnchor, constant: -50),
            leftArrowImageView.topAnchor.constraint(equalTo: modalView.centerYAnchor, constant: -80),
            leftArrowImageView.bottomAnchor.constraint(equalTo: modalView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightArrowImageView.leadingAnchor.constraint(equalTo: modalView.centerXAnchor, constant: 50),
            rightArrowImageView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            rightArrowImageView.topAnchor.constraint(equalTo: modalView.centerYAnchor, constant: -80),
            rightArrowImageView.bottomAnchor.constraint(equalTo: modalView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passButtonImageView.centerXAnchor.constraint(equalTo: leftArrowImageView.centerXAnchor),
            passButtonImageView.centerYAnchor.constraint(equalTo: leftArrowImageView.centerYAnchor, constant: 40),
            likeButtonImageView.centerXAnchor.constraint(equalTo: rightArrowImageView.centerXAnchor),
            likeButtonImageView.centerYAnchor.constraint(equalTo: rightArrowImageView.centerYAnchor, constant: 40)
        ])
        
        view.addSubview(modalView)
        
    }
    
    private func getProductTinder() {
        featureProvider.getProductTinder { result in
            switch result {
                case .success(let tinderObject):
                    let imageURLs = tinderObject.data.images
                    
                    guard let imageURLs = imageURLs else { return }
                    
                    let dispatchGroup = DispatchGroup()
                    
                    for (index, urlStr) in imageURLs.enumerated() {
                        if let url = URL(string: urlStr) {
                            dispatchGroup.enter()
                            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                                
                                defer {
                                    dispatchGroup.leave()
                                }
                                if let error = error {
                                    print("Error downloading image: \(error)")
                                } else if let data = data, let image = UIImage(data: data) {
                                    // Update the card model with the downloaded image
                                    self.cardModels[index].image = image
                                    print(data)
                                }
                            }
                            task.resume()
                        }
                    }
                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        // This block will be called when all download tasks are completed.
                        // You can update your UI here once all images have been downloaded.
                        self.cardStack.reloadData()
                    }
                    
                    // Print or use the retrieved data as needed
                    print("Images: \(imageURLs)")
                    
                case .failure(let error):
                    // Handle the error
                    print("Error fetching ProductTinder: \(error)")
            }
        }
    }
    
    @objc
    private func handleShift(_ sender: UIButton) {
        cardStack.shift(withDistance: sender.tag == 1 ? -1 : 1, animated: true)
    }
    
    @objc func closeButtonTapped(_ sender: Any) {
        modalView.isHidden = true
    }
    
}

// MARK: Data Source + Delegates

extension SwipeViewController: ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 120
        card.swipeDirections = [.left, .up, .right]
        for direction in card.swipeDirections {
            card.setOverlay(TinderCardOverlay(direction: direction), forDirection: direction)
        }
        
        let model = cardModels[index]
        card.content = TinderCardContentView(withImage: model.image)
        //        card.footer = TinderCardFooterView(withTitle: "\(model.name), \(model.age)", subtitle: model.occupation)
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardModels.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        LKProgressHUD.show()
        
        let storyboard = UIStoryboard.swipe
        guard let swipeResultVC = storyboard.instantiateViewController(withIdentifier: "SwipeResult") as? SwipeResultViewController else { return }
        swipeResultVC.modalPresentationStyle = .fullScreen
        
        if styleACount > styleBCount && styleACount > styleCCount {
            UserDataManager.shared.style = "A"
        } else if styleBCount > styleACount && styleBCount > styleCCount {
            UserDataManager.shared.style = "B"
        } else if styleCCount > styleACount && styleCCount > styleBCount {
            UserDataManager.shared.style = "C"
        } else {
            UserDataManager.shared.style = "A"
        }
        
        present(swipeResultVC, animated: false)
        print("Swiped all cards!導覽至結果頁面")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        //        print("Undo \(direction) swipe on \(cardModels[index].name)")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        //        print("Swiped \(direction) on \(cardModels[index].name)")
        if direction == .right {
            switch index {
                case 0:
                    styleACount += 1
                case 1:
                    styleBCount += 1
                case 2:
                    styleCCount += 1
                case 3:
                    styleACount += 1
                default:
                    break
            }
        }
       
        print("A: \(styleACount), B: \(styleBCount), C: \(styleCCount)")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
    
    func didTapButton(button: TinderButton) {
        switch button.tag {
            case 1:
                cardStack.undoLastSwipe(animated: true)
            case 2:
                cardStack.swipe(.left, animated: true)
            case 3:
                cardStack.swipe(.up, animated: true)
            case 4:
                cardStack.swipe(.right, animated: true)
            case 5:
                cardStack.reloadData()
            default:
                break
        }
    }
}
