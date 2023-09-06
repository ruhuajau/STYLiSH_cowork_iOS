//
//  ShowSizeCollectionViewCell.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor.black
        label.textColor = UIColor.hexStringToUIColor(hex: "AAAAAA")
        label.textAlignment = .center
        label.backgroundColor = UIColor.hexStringToUIColor(hex: "F0F0F0")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        return label
    }()
    
    override func awakeFromNib() {
            super.awakeFromNib()

            // Add a border to the color square
            sizeLabel.layer.borderWidth = 2
            sizeLabel.layer.borderColor = UIColor.white.cgColor
            sizeLabel.layer.masksToBounds = true
        }

    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           addSubview(sizeLabel)
           sizeLabel.translatesAutoresizingMaskIntoConstraints = false
           
        NSLayoutConstraint.activate([
               sizeLabel.topAnchor.constraint(equalTo: topAnchor),
               sizeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
               sizeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
               sizeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    var isItemSelected: Bool = false {
        didSet {
            if isItemSelected {
                let newOuterBorderLayer = CALayer()
                newOuterBorderLayer.borderWidth = 2.0
                newOuterBorderLayer.borderColor = UIColor.white.cgColor
                newOuterBorderLayer.frame = sizeLabel.bounds.inset(by: UIEdgeInsets(top: 2, left:2, bottom: 2, right: 2))
                
                sizeLabel.layer.borderWidth = 1
                sizeLabel.layer.addSublayer(newOuterBorderLayer)
                sizeLabel.layer.borderColor = UIColor.black.cgColor
            } else {
                sizeLabel.layer.borderWidth = 2
                sizeLabel.layer.borderColor = UIColor.white.cgColor
                sizeLabel.layer.mask = nil
            }
        }
    }

}
