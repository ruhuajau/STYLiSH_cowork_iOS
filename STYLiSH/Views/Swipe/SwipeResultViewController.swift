//
//  SwipeResultViewController.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SwipeResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let authVC = UIStoryboard.auth.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    
    }
    
    @IBAction func backToHomePageButtonTapped(_ sender: Any) {
        guard let mainVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        mainVC.modalPresentationStyle = .overCurrentContext
        present(mainVC, animated: false, completion: nil)
    }
    
}
