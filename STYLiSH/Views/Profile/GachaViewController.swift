//
//  gachaViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class GachaViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var spinningView: UIView!
    
    @IBOutlet weak var pullButton: UIButton!
    
    @IBOutlet weak var congratsMessage: UILabel!
    
    
    @IBOutlet weak var goBackButton: UIButton!
    
    var isSpinning = false
    
    let gachaItems = [
        "💰 10% off! ": 0.6,
        "🎁 25% off! ": 0.3,
        "🌟 50% off! ": 0.1
    ]
    
    // Array of different background colors
    let backgroundColors: [UIColor] = [
        UIColor.hexStringToUIColor(hex: "#C1FFC1"), // Mint Green
        UIColor.hexStringToUIColor(hex: "#E6E6FA"), // Lavender
        UIColor.hexStringToUIColor(hex: "#AEE0E0"), // Baby Blue
        UIColor.hexStringToUIColor(hex: "#FFDAB9"), // Peach
        UIColor.hexStringToUIColor(hex: "#FFF44F")  // Lemon Yellow
    ]
    
    var colorChangeTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goBackButton.isHidden = true
        
        // Style the "Pull" button
        pullButton.backgroundColor = UIColor.blue
        pullButton.setTitleColor(UIColor.white, for: .normal)
        pullButton.layer.cornerRadius = 10
        
        // Style the spinning view
        spinningView.layer.cornerRadius = spinningView.frame.size.width / 2
        spinningView.layer.borderWidth = 2
        spinningView.layer.borderColor = UIColor.lightGray.cgColor
        congratsMessage.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func twistGacha(_ sender: Any) {
        if !isSpinning {
            // Disable the button during the spinning animation
            pullButton.isEnabled = false
            
            // Start the spinning animation
            startSpinning()
        }
        pullButton.isEnabled = false
        pullButton.alpha = 0.6
    }
    
    func startSpinning() {
        isSpinning = true
        
        // Create a spinning animation
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = CGFloat.pi * 8  // Full rotation (8 * pi)
        animation.duration = 1  // Spin quickly in 1 second
        animation.isCumulative = true
        animation.repeatCount = 1  // Spin only once
        
        // Add animation to the spinning view's layer
        spinningView.layer.add(animation, forKey: "rotationAnimation")
        
        // After the spinning animation completes, display the result
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopSpinning()
        }
        
        // Change background color continuously during spinning animation
        changeBackgroundColor()
        
    }
    
    func stopSpinning() {
        // Disable the "Pull" button
        pullButton.isEnabled = false
        
        // Stop the spinning animation
        spinningView.layer.removeAllAnimations()
        
        // Stop changing the background color
        stopColorChanging()
        
        // Enable the "Pull" button
        pullButton.isEnabled = true
        
        // Convert dictionary keys to an array
        let itemsArray = Array(gachaItems.keys)
        
        // Determine and display the gacha result
        let randomIndex = Int.random(in: 0..<itemsArray.count)
        let selectedItem = itemsArray[randomIndex]
        
        // Update the result label with the selected coupon emoji
        resultLabel.text = "\(selectedItem)"
        congratsMessage.isHidden = false
        congratsMessage.textColor = .white
        congratsMessage.text = "恭喜您！快來逛逛吧❤️"
        goBackButton.isHidden = false
        
        isSpinning = false
    }
    
    func changeBackgroundColor() {
        colorChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let randomColor = self.backgroundColors.randomElement() ?? .clear
            self.spinningView.backgroundColor = randomColor
        }
    }
    
    func stopColorChanging() {
        colorChangeTimer?.invalidate()
        colorChangeTimer = nil
    }
    
    
    @IBAction func goBackToLobby(_ sender: Any) {
    }
}
