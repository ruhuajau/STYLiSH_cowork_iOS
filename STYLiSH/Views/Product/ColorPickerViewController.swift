//
//  ColorPickerViewController.swift
//  STYLiSH
//
//  Created by 趙如華 on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Kingfisher

class ColorPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HairColorSelectionDelegate, SkinColorSelectionDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var containerVIew: UIView!
    
    var product: Product?
    
    var selectedHairColor: String?
    var selectedSkinColor: String?
    private var colorStrings: [String] = []
    
    private let trackingProvider = TrackingProvider()
    private let featureProvider = FeatureProvider()
    private var cid: String?
    private var memberID: String?
    private var eventDate: String?
    private var eventTimestamp: Int?
    
    var containerVC: ShowColorViewController?
        
    @IBOutlet weak var colorPickerTableView: UITableView!
    
    @IBOutlet weak var showResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerVIew.isHidden = true
        
        colorPickerTableView.delegate = self
        colorPickerTableView.dataSource = self
        colorPickerTableView.separatorColor = .none
        
        showResultButton.isEnabled = false
        showResultButton.alpha = 0.6
        
        showImage()
        //print("product information: \(product)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let containerVC = segue.destination as? ShowColorViewController {
                // Set the product property of the container view controller
                containerVC.product = self.product
                self.containerVC = containerVC
            }
        }
    
    func configureEventDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        self.eventDate = formattedDate
    }
    
    func configureEventTimestamp() {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        self.eventTimestamp = currentTimestamp
    }

    
    func showImage() {
        if let imageURLString = product?.mainImage, let imageURL = URL(string: imageURLString) {
            // Assuming you have an UIImageView named 'productImageView' in your storyboard
            productImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success(let value):
                    print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
                    // Set the loaded image to your productImageView or any other UIImageView
                    self.productImageView.image = value.image
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
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
                if let titleString = product?.title {
                    cell.titleLabel.text = titleString
                }
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
        //print("hair:\(colorCode)")
        checkEnableShowResultButton()
    }
    
    func didSelectSkinColor(_ colorCode: String) {
        self.selectedSkinColor = colorCode
        //print("skin:\(colorCode)")
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
    
    @IBAction func showResultButtonTapped(_ sender: Any) {
        containerVIew.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if let cid = UserDataManager.shared.cid {
            self.cid = cid
        } else {
            let newUUID = UUID()
            let cidString = newUUID.uuidString
            self.cid = cidString
        }
        
        if let memberID = UserDataManager.shared.memberID {
            self.memberID = memberID
        }
        
        configureEventDate()
        configureEventTimestamp()
        
        for color in product!.colors {
            self.colorStrings.append(color.code)
        }
        
        print("\(cid), \(memberID), \(eventDate), \(eventTimestamp), \(selectedHairColor), \(selectedSkinColor), \(colorStrings)")

        
        featureProvider.getColorRecommendation(
            cid: cid!,
            memberID: memberID,
            eventDate: eventDate!,
            deviceOS: "iOS",
            eventTimestamp: eventTimestamp!,
            hairColor: selectedHairColor!,
            skinColor: selectedSkinColor!,
            colors: colorStrings
        ) { result in
            // Handle the result of the getColorRecommendation function here
            switch result {
            case .success(let colorRecommendation):
                // Handle the successful result
                self.updateContainerView(with: colorRecommendation)
                print("Recommended color: \(colorRecommendation)")
            case .failure(let error):
                // Handle the error
                print("Error: \(error.localizedDescription)")
            }
        }
        
        postTrackingEventCalculateColor()

    }
    
    private func updateContainerView(with color: String) {
        if let showColorVC = self.containerVC {
            showColorVC.showColorView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            showColorVC.colorRecommend = color
        }

    }
    
    private func postTrackingEventCalculateColor() {
        print("開始計算你的顏色")
        if let cid = UserDataManager.shared.cid {
            self.cid = cid
        } else {
            let newUUID = UUID()
            let cidString = newUUID.uuidString
            UserDataManager.shared.cid = cidString
            self.cid = cidString
        }
        
        if let memberID = UserDataManager.shared.memberID {
            self.memberID = memberID
        }
        
        configureEventDate()
        configureEventTimestamp()
        // swiftlint:disable:next line_length
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "tinder", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("cid: \(self.cid), memberID: \(self.memberID), eventDate: \(self.eventDate), eventTimestamp: \(self.eventTimestamp)")
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
}
