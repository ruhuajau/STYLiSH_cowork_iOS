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
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        postTrackingEvent()
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
    
    private func postTrackingEvent() {
        print("進入註冊登入頁")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "signin_signup", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    func configureEventDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        eventDate = formattedDate
    }
    
    func configureEventTimestamp() {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        eventTimestamp = currentTimestamp
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
                    DispatchQueue.main.async {
                        guard let mainVC = UIStoryboard.main.instantiateInitialViewController() else { return }
                        mainVC.modalPresentationStyle = .overCurrentContext
                        self?.present(mainVC, animated: false, completion: nil)
                    }
                    
                case .failure:
                    LKProgressHUD.showSuccess(text: "STYLiSH 登入失敗!")
                    print("STYLiSH 登入失敗")
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
                    DispatchQueue.main.async {
                        guard let mainVC = UIStoryboard.main.instantiateInitialViewController() else { return }
                        mainVC.modalPresentationStyle = .overCurrentContext
                        self?.present(mainVC, animated: false, completion: nil)
                    }
                case .failure:
                    LKProgressHUD.showSuccess(text: "STYLiSH 註冊失敗!")
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
