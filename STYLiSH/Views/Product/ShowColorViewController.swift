//
//  showColorViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ShowColorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

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
            sizeCollectionView.reloadData()
        }
    }
    var availableSizes: [String] = []
    var sizes: [String] = []
    var selectedIndexPath: IndexPath? = nil
    
    var size: String?{
        didSet{
            updateStockForSelectedSize()
            addCartButton.isEnabled = true
            addCartButton.alpha = 1
        }
    }
    
    var stockForSelectedSize: Int? {
        didSet {
            updateUI()
        }
    }
    
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.cornerRadius = 0
        //textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        //textField.isEnabled = false
        
        plusButton.layer.borderWidth = 1.0
        //plusButton.layer.borderColor = UIColor.black.cgColor
        
        minusButton.layer.borderWidth = 1.0
        //minusButton.layer.borderColor = UIColor.gray.cgColor
        //minusButton.isEnabled = false
        
        showColorView.layer.borderWidth = 1.0
        //showColorView.layer.borderColor = UIColor.black.cgColor
        
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        sizeCollectionView.register(SizeCollectionViewCell.self, forCellWithReuseIdentifier: "SizeCollectionViewCell")
                
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40) // Adjust size as needed
        layout.minimumInteritemSpacing = 11
        layout.minimumLineSpacing = 10
        
        sizeCollectionView.collectionViewLayout = layout
        sizeCollectionView.backgroundColor = .white
        
        updateUI()
        addCartButton.isEnabled = false
        addCartButton.alpha = 0.6
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
    
    func updateStockForSelectedSize() {
        guard let product = product, let colorRecommend = colorRecommend, let size = size else {
                return
            }

            // Iterate through the variants to find the stock for the selected color and size
            var stockForSelectedSize = 0
            for variant in product.variants {
                if variant.colorCode == colorRecommend && variant.size == size {
                    stockForSelectedSize = variant.stock
                    break // No need to continue searching
                }
            }
        self.stockForSelectedSize = stockForSelectedSize
            print("Stock for \(colorRecommend) - Size \(size): \(stockForSelectedSize)")
            stockLabel.text = "庫存：\(stockForSelectedSize)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell else {
                fatalError("Failed to dequeue a SizeCollectionViewCell.")
            }
        let size = sizes[indexPath.item]
        cell.sizeLabel.text = size
        cell.sizeLabel.textColor = availableSizes.contains(size) ? .black : UIColor.hexStringToUIColor(hex: "AAAAAA")
        cell.isItemSelected = selectedIndexPath == indexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect the previous selected color square
        if let selectedIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: selectedIndexPath) as? SizeCollectionViewCell
            previousCell?.isItemSelected = false
        }
        
        // Select the current color square
        let cell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell
        cell?.isItemSelected = true
        
        // Keep track of the selected index path
        selectedIndexPath = indexPath
        self.size = sizes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let size = sizes[indexPath.item]
        return availableSizes.contains(size)

    }
    
    func updateUI() {
        if stockForSelectedSize != nil {
            
            if stockForSelectedSize == 0 {
                plusButton.isEnabled = false
                minusButton.isEnabled = false
                textField.isEnabled = false
            } else {
                if let quantity = Int(textField.text ?? "0") {
                    plusButton.isEnabled = quantity < stockForSelectedSize!
                    minusButton.isEnabled = quantity > 1
                    textField.isEnabled = true
                    self.quantity = quantity
                    //delegate?.sendingQuantity(quantity: quantity)
                    //print(quantity)
                    
                }
            }
        } else {
            plusButton.isEnabled = false
            minusButton.isEnabled = false
            textField.isEnabled = false
            self.quantity = nil
            //delegate?.sendingQuantity(quantity: 0)
        }
        
        let isEnabled1 = plusButton.isEnabled
        plusButton.setTitleColor(isEnabled1 ? .black : .gray, for: .normal)
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = isEnabled1 ? UIColor.black.cgColor : UIColor.gray.cgColor
        
        let isEnabled2 = minusButton.isEnabled
        minusButton.setTitleColor(isEnabled2 ? .black : .gray, for: .normal)
        minusButton.layer.borderWidth = 1.0
        minusButton.layer.borderColor = isEnabled2 ? UIColor.black.cgColor : UIColor.gray.cgColor
        
        let isEnabled3 = textField.isEnabled
        textField.textColor = isEnabled3 ? .black : .gray
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = isEnabled3 ? UIColor.black.cgColor : UIColor.gray.cgColor
    }
    
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        if var quantity = Int(textField.text ?? "0") {
            quantity += 1
            textField.text = "\(quantity)"
            updateUI()
        }
    }
    
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if var quantity = Int(textField.text ?? "0") {
            quantity -= 1
            textField.text = "\(quantity)"
            updateUI()
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == textField {
            if let quantityText = textField.text, let quantity = Int(quantityText) {
                textField.text = "\(quantity)"
                updateUI()
            }
        }
        return true
    }
    
}
    
