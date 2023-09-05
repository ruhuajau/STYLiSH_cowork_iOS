//
//  ColorPickerSkinTableViewCell.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol SkinColorSelectionDelegate: AnyObject {
    func didSelectSkinColor(_ colorCode: String)
}

class ColorPickerSkinTableViewCell: UITableViewCell {
    
    weak var delegate: SkinColorSelectionDelegate?
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var skinCollectionView: UICollectionView!
    
    // Constants for border styling
        let borderWidth: CGFloat = 1.0
        let borderColor: UIColor = .black
    
    var selectedButton: SelectedButton?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func button1Tapped(_ sender: UIButton) {
        selectedButton = .button1
        updateButtonStates()
        
        let colorCode = "F9DDB3"
        delegate?.didSelectSkinColor(colorCode)
    }

    @IBAction func button2Tapped(_ sender: UIButton) {
        selectedButton = .button2
        updateButtonStates()
        
        let colorCode = "FAD1B8"
        delegate?.didSelectSkinColor(colorCode)
    }

    @IBAction func button3Tapped(_ sender: UIButton) {
        selectedButton = .button3
        updateButtonStates()
        
        let colorCode = "E4AE86"
        delegate?.didSelectSkinColor(colorCode)
    }

    private func updateButtonStates() {
        switch selectedButton {
        case .button1:
            button1.isSelected = true
            configureButton(button: button1, selected: true)
            configureButton(button: button2, selected: false)
            configureButton(button: button3, selected: false)
        case .button2:
            configureButton(button: button1, selected: false)
            button2.isSelected = true
            configureButton(button: button2, selected: true)
            configureButton(button: button3, selected: false)
        case .button3:
            configureButton(button: button1, selected: false)
            configureButton(button: button2, selected: false)
            button3.isSelected = true
            configureButton(button: button3, selected: true)
        case .none:
            configureButton(button: button1, selected: false)
            configureButton(button: button2, selected: false)
            configureButton(button: button3, selected: false)
        }
    }

    private func configureButton(button: UIButton, selected: Bool) {
        if selected {
            button.layer.borderWidth = borderWidth
            button.layer.borderColor = borderColor.cgColor
            
            // Add an additional white border
            let newOuterBorderLayer = CALayer()
            newOuterBorderLayer.borderWidth = 2.0
            newOuterBorderLayer.borderColor = UIColor.white.cgColor
            newOuterBorderLayer.frame = button.bounds.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
            button.layer.addSublayer(newOuterBorderLayer)
        } else {
            button.layer.borderWidth = 0
            button.layer.borderColor = nil
            
            // Remove the additional white border
            if let sublayers = button.layer.sublayers {
                for layer in sublayers {
                    if layer.borderColor == UIColor.white.cgColor {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    }


}
