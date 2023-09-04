//
//  ColorPickerViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HairColorSelectionDelegate, SkinColorSelectionDelegate {

    @IBOutlet weak var productImage: UIImageView!
    
    var selectedHairColor: String?
    var selectedSkinColor: String?
    var product: Product?
    
    @IBOutlet weak var colorPickerTableView: UITableView!
    
    @IBOutlet weak var showResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPickerTableView.delegate = self
        colorPickerTableView.dataSource = self
        colorPickerTableView.separatorColor = .none
        
        showResultButton.isEnabled = false
        showResultButton.alpha = 0.6
        //print(product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerTitleTableViewCell", for: indexPath) as? ColorPickerTitleTableViewCell{
                return cell }
        case 1:
            if let cell = (tableView.dequeueReusableCell(withIdentifier: "ColorPickerHairTableViewCell", for: indexPath) as? ColorPickerHairTableViewCell) {
                cell.delegate = self
                return cell }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerSkinTableViewCell", for: indexPath) as? ColorPickerSkinTableViewCell {
                cell.delegate = self
                return cell }
        default:
            break
        }
        return UITableViewCell()
    }

    func didSelectHairColor(_ colorCode: String) {
        self.selectedHairColor = colorCode
        print("hair:\(colorCode)")
        checkEnableShowResultButton()
    }
    
    func didSelectSkinColor(_ colorCode: String) {
        self.selectedSkinColor = colorCode
        print("skin:\(colorCode)")
        checkEnableShowResultButton()
    }

    // Function to check and enable/disable the showResultButton
        private func checkEnableShowResultButton() {
            if let hairColor = self.selectedHairColor, let skinColor = self.selectedSkinColor {
                // Both colors are selected, enable the button
                showResultButton.isEnabled = true
                showResultButton.alpha = 1
            } else {
                // At least one color is missing, disable the button
                showResultButton.isEnabled = false
                showResultButton.alpha = 0.6
            }
        }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
