//
//  ColorPickerHairCollectionViewCell.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ColorPickerHairCollectionViewCell: UICollectionViewCell {
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        return view
    }()

    var isItemSelected: Bool = false {
        didSet {
            if isItemSelected {
                                                    
                // Add an additional black border when selected
                let newOuterBorderLayer = CALayer()
                newOuterBorderLayer.borderWidth = 2.0
                newOuterBorderLayer.borderColor = UIColor.white.cgColor
                newOuterBorderLayer.frame = colorView.bounds.inset(by: UIEdgeInsets(top: 2, left:2, bottom: 2, right: 2))
                
                colorView.layer.borderWidth = 1
                colorView.layer.addSublayer(newOuterBorderLayer)
                colorView.layer.borderColor = UIColor.black.cgColor
                
                } else {
                colorView.layer.borderWidth = 2
                colorView.layer.borderColor = UIColor.white.cgColor
                colorView.layer.mask = nil  // Remove the mask when not selected
                 }
             }
    
        }
    

override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
}

func setupViews() {
    // Add colorView as a subview
    addSubview(colorView)
    
    // Setup constraints for colorView to fill the cell
    colorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    colorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    colorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    colorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

