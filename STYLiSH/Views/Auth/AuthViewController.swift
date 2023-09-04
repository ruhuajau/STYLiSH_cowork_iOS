//
//  AuthViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit
import JGProgressHUD
import IQKeyboardManagerSwift

class AuthViewController: STBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let userProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = isEnableResignOnTouchOutside
        
        contentView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.contentView.isHidden = false
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = !isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = !isEnableResignOnTouchOutside
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onNativeLogin(_ sender: Any) {
        LKProgressHUD.show()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            LKProgressHUD.dismiss()
            return
        }
        
        userProvider.nativeSignIn(email: email, password: password, completion: { [weak self] result in
            LKProgressHUD.dismiss()
            
            switch result {
                case .success:
                    LKProgressHUD.showSuccess(text: "STYLiSH 登入成功")
                    print("STYLiSH 登入成功")
                case .failure:
                    LKProgressHUD.showSuccess(text: "STYLiSH 登入失敗!")
                    print("STYLiSH 登入失敗")
            }
            DispatchQueue.main.async {
                self?.presentingViewController?.dismiss(animated: false, completion: nil)
                
                guard let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() else { return }
                lobbyVC.modalPresentationStyle = .overCurrentContext
                self?.present(lobbyVC, animated: false, completion: nil)
            }
        })
    }
    
    @IBAction func onNativeSignUp(_ sender: Any) {
        LKProgressHUD.show()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            LKProgressHUD.dismiss()
            return
        }
        
        userProvider.nativeSignup(email: email, password: password, completion: { [weak self] result in
            LKProgressHUD.dismiss()
            print(email)
            print(password)
            switch result {
                case .success:
                    LKProgressHUD.showSuccess(text: "STYLiSH 註冊成功")
                    let alert = UIAlertController(title: "註冊成功", message: "已註冊", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                case .failure:
                    LKProgressHUD.showSuccess(text: "STYLiSH 註冊失敗!")
            }
            DispatchQueue.main.async {
                self?.presentingViewController?.dismiss(animated: false, completion: nil)
                
                guard let lobbyVC = UIStoryboard.lobby.instantiateInitialViewController() else { return }
                lobbyVC.modalPresentationStyle = .overCurrentContext
                self?.present(lobbyVC, animated: false, completion: nil)
            }
        })
    }
    
    //    @IBAction func onFacebookLogin() {
    //        userProvider.loginWithFaceBook(from: self, completion: { [weak self] result in
    //            switch result {
    //            case .success(let token):
    //                self?.onSTYLiSHSignIn(token: token)
    //            case .failure:
    //                LKProgressHUD.showSuccess(text: "Facebook 登入失敗!")
    //            }
    //        })
}

//    private func onSTYLiSHSignIn(token: String) {
//        LKProgressHUD.show()
//
//        userProvider.signInToSTYLiSH(fbToken: token, completion: { [weak self] result in
//            LKProgressHUD.dismiss()
//
//            switch result {
//            case .success:
//                LKProgressHUD.showSuccess(text: "STYLiSH 登入成功")
//            case .failure:
//                LKProgressHUD.showSuccess(text: "STYLiSH 登入失敗!")
//            }
//            DispatchQueue.main.async {
//                self?.presentingViewController?.dismiss(animated: false, completion: nil)
//            }
//        })
//    }
