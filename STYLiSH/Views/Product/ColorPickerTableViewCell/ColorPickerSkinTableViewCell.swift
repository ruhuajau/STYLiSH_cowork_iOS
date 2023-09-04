//
//  ColorPickerSkinTableViewCell.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ColorPickerSkinTableViewCell: UITableViewCell {

    @IBOutlet weak var skinCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
