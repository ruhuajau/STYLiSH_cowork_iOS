//
//  UserManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import FBSDKLoginKit

typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {
    case noToken = "讀取 Facebook 資料發生錯誤！"
    case userCancel
    case denineEmailPermission = "請允許存取 Facebook email！"
}

enum STYLiSHSignInError: Error {
    case noToken
}

class UserProvider {
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    func nativeSignIn(email: String, password: String, completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(STUserRequest.signin(email: email, password: password), completion: { result in
            switch result {
                case .success(let data):
                    do {
                        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
                        KeyChainManager.shared.token = userObject.accessToken
                        guard let memberID = userObject.user.id else { fatalError("Cannot get member ID") }
                        UserDataManager.shared.memberID = String(memberID)
                        completion(Result.success(()))
                    } catch {
                        completion(Result.failure(error))
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(Result.failure(error))
                    print(error.localizedDescription)
            }
        })
    }
    
    func nativeSignup(email: String, password: String, completion: @escaping (Result<Void>) -> Void) {
        let request = STUserRequest.signup(email: email, password: password)
        HTTPClient.shared.request(request, completion: { result in
            switch result {
                case .success(let data):
                    do {
                        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
                        KeyChainManager.shared.token = userObject.accessToken
                        guard let memberID = userObject.user.id else { fatalError("Cannot get member ID") }
                        UserDataManager.shared.memberID = String(memberID)
                        completion(Result.success(()))
                    } catch {
                        completion(Result.failure(error))
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    completion(Result.failure(error))
                    print(error.localizedDescription)
            }
        })
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
    
    func loginWithFaceBook(from: UIViewController, completion: @escaping FacebookResponse) {
        LoginManager().logIn(permissions: ["email"], from: from, handler: { (result, error) in
            if let error = error { return completion(Result.failure(error)) }
            guard let result = result else {
                let fbError = FacebookError.noToken
                LKProgressHUD.showFailure(text: fbError.rawValue)
                return completion(Result.failure(fbError))
            }
            
            switch result.isCancelled {
                case true: break
                case false:
                    guard result.declinedPermissions.contains("email") == false else {
                        let fbError = FacebookError.denineEmailPermission
                        LKProgressHUD.showFailure(text: fbError.rawValue)
                        return completion(Result.failure(fbError))
                    }
                    guard let token = result.token?.tokenString else {
                        let fbError = FacebookError.noToken
                        LKProgressHUD.showFailure(text: fbError.rawValue)
                        return completion(Result.failure(fbError))
                    }
                    completion(Result.success(token))
            }
        })
    }
    
    //    func checkout(order: Order, prime: String, completion: @escaping (Result<Reciept>) -> Void) {
    //        guard let token = KeyChainManager.shared.token else {
    //            return completion(Result.failure(STYLiSHSignInError.noToken))
    //        }
    //        let body = CheckoutAPIBody(order: order, prime: prime)
    //        let request = STUserRequest.checkout(
    //            token: token,
    //            body: try? JSONEncoder().encode(body)
    //        )
    //        HTTPClient.shared.request(request, completion: { result in
    //            switch result {
    //            case .success(let data):
    //                do {
    //                    let reciept = try JSONDecoder().decode(STSuccessParser<Reciept>.self, from: data)
    //                    DispatchQueue.main.async {
    //                        completion(Result.success(reciept.data))
    //                    }
    //                } catch {
    //                    completion(Result.failure(error))
    //                }
    //            case .failure(let error):
    //                completion(Result.failure(error))
    //            }
    //        })
    //    }
    
    func checkoutWithCash(token: String, completion: @escaping (Result<Void>) -> Void) {
        
        let orders = StorageManager.shared.orders
        
        var newListArray: [NewList] = []
        
        configureEventDate()
        configureEventTimestamp()
        
        for order in orders {
            if let product = order.product,
               let productName = product.title,
               let color = order.selectedColor?.name,
               let colorCode = order.selectedColor?.code,
               let productSize = order.seletedSize {
                let newList = NewList(
                    productID: Int(product.id),
                    productName: productName,
                    productPrice: Int(product.price),
                    color: OrderColor(name: color, code: colorCode),
                    productSize: productSize,
                    productQty: Int(order.amount),
                    orderDate: eventDate!,
                    orderTimestamp: eventTimestamp!
                )
                newListArray.append(newList)
            }
        }
        
        
        let request = STUserRequest.checkoutWithCash(token: token, list: newListArray)
        
        HTTPClient.shared.request(request, completion: { result in
            switch result {
                case .success:
                    // Handle successful checkout with cash
                    completion(Result.success(()))
                case .failure(let error):
                    completion(Result.failure(error))
            }
        })
    }
    
    func getUserProfile(completion: @escaping (Result<User>) -> Void) {
        guard let token = KeyChainManager.shared.token else {
            return completion(Result.failure(STYLiSHSignInError.noToken))
        }
        let request = STUserRequest.profile(token: token)
        print(token)
        HTTPClient.shared.request(request, completion: { result in
            switch result {
                case .success(let data):
                    do {
//                        let user = try JSONDecoder().decode(STSuccessParser<User>.self, from: data)
//                        DispatchQueue.main.async {
//                            completion(Result.success(user.data))
//                        }
                        print("成功進入profile")
                    } catch {
                        completion(Result.failure(error))
                    }
                case .failure(let error):
                    completion(Result.failure(error))
                    print(error.localizedDescription)
            }
        })
    }
}
