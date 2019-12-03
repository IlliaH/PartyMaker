//
//  StorageServiceTest.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-03.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
@testable import PartyMaker

class StorageServiceTest {
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func uploadFile(from url : URL, picture: Data, completion: @escaping (String?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
            
         // Parse JSON and print in console
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                    if let dictionary = json as? [String: Any] {
                        if let url = dictionary["url"] as? String, !url.isEmpty {
                            completion(url, nil)
                            return
                        }
                        if let message = dictionary["message"] as? String {
                            completion(nil, ServiceError.ServerMessage(message))
                        }
                        else {
                            completion(nil, ServiceError.NoResponseFromServer)
                        }
                    }
                    else {
                        completion(nil, ServiceError.NoResponseFromServer)
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            } else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }).resume()
    }
    
    func downloadFile(from url : URL, pictureUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: {
            (data, _, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    completion(data, nil)
                }
                else {
                    completion(nil, ServiceError.NoResponseFromServer)
                }
            }
        }).resume()
    }
}
