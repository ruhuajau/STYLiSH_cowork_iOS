//
//  FeatureProvider.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

class FeatureProvider {
    
    let decoder = JSONDecoder()
    
    func getColorRecommendation(
        cid: String,
        memberID: String?,
        eventDate: String,
        eventTimestamp: Int,
        hairColor: String,
        skinColor: String,
        completion: @escaping (Result<String>) -> Void
    ) {
        let request = STFeatureRequest.colorPicker(
            cid: cid,
            memberID: memberID,
            eventDate: eventDate,
            eventTimestamp: eventTimestamp,
            hairColor: hairColor,
            skinColor: skinColor
        )
        
        HTTPClient.shared.request(request) { result in
            switch result {
                case .success(let data):
                    do {
                        let colorData = try self.decoder.decode(
                            ColorData.self,
                            from: data
                        )
                        DispatchQueue.main.async {
                            completion(Result.success(colorData.data.recommendColor))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(Result.failure(STHTTPClientError.decodeDataFail))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                    }
            }
        }
    }
    
    func getProductTinder(completion: @escaping (Result<TinderObject>) -> Void) {
            let request = STFeatureRequest.productTinder

            HTTPClient.shared.request(request) { result in
                switch result {
                case .success(let data):
                    do {
                        let tinderObject = try self.decoder.decode(
                            TinderObject.self,
                            from: data
                        )
                        DispatchQueue.main.async {
                            completion(Result.success(tinderObject))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(Result.failure(STHTTPClientError.decodeDataFail))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                    }
                }
            }
        }
}
