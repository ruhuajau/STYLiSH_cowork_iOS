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
    
    @IBOutlet weak var stockLabel: UILabel!
    
    var product: Product?{
        didSet {
            self.sizes = product!.sizes
        }
    }
    var colorRecommend: String? {
        didSet {
            updateStockForSelectedColor()
        }
    }
    var availableSizes: [String] = []
    var sizes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.cornerRadius = 0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = UIColor.black.cgColor
        
        minusButton.layer.borderWidth = 1.0
        minusButton.layer.borderColor = UIColor.gray.cgColor
        
        showColorView.layer.borderWidth = 1.0
        showColorView.layer.borderColor = UIColor.black.cgColor
        
        print("product data: \(product)")
    }
    
    private func updateStockForSelectedColor() {
            guard let product = product, let colorRecommend = colorRecommend else {
                return
            }

            // Iterate through the variants to calculate the stock for the selected color
            var stockForSelectedColor = 0
            for variant in product.variants {
                if variant.colorCode == colorRecommend && variant.stock > 0 {
                    availableSizes.append(variant.size)
                }
            }
        
        print("Stock for \(colorRecommend): \(stockForSelectedColor)")
        stockLabel.text = "庫存：\(stockForSelectedColor)"
        }
    
}
    
