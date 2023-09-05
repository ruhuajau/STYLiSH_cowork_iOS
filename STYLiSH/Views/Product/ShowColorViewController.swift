//
//  showColorViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ShowColorViewController: UIViewController {

    @IBOutlet weak var showColorView: UIView!
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var addCartButton: UIButton!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.cornerRadius = 0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = UIColor.black.cgColor
        
        minusButton.layer.borderWidth = 1.0
        minusButton.layer.borderColor = UIColor.gray.cgColor
        
        print("product data: \(product)")
    }
    
}
