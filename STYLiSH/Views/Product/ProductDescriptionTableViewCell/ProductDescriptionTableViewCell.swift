//
//  ProductDescriptionTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: AnyObject {
    func sendColorAnalysisButtonTapped()
}

class ProductDescriptionTableViewCell: ProductBasicCell {
    
    weak var delegate: ColorPickerDelegate?
    
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var idLbl: UILabel!

    @IBOutlet weak var detailLbl: UILabel!

    @IBOutlet weak var colorAnalysisButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutCell(product: Product) {
        titleLbl.text = product.title
        priceLbl.text = "NT$ \(product.price)"
        idLbl.text = String(product.id)
        detailLbl.text = product.story
    }
    
    @IBAction func colorAnalysisButtonTapped(_ sender: Any) {
        delegate?.sendColorAnalysisButtonTapped()
    }
}
