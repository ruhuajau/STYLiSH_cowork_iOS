//
//  ColorPickerViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var colorPickerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPickerTableView.delegate = self
        colorPickerTableView.dataSource = self
        colorPickerTableView.separatorColor = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
                return cell }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerSkinTableViewCell", for: indexPath) as? ColorPickerSkinTableViewCell {
                return cell }
        default:
            break
        }
        return UITableViewCell()
    }

    
}
