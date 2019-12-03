//
//  AuthServiceTest.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-03.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
@testable import PartyMaker

class AuthServiceTest {
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func Login(from url : URL, email: String, password: String, remember_me: Bool, completion: @escaping (String?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
            // Parse JSON and print in console
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let dictionary = json as? [String: Any] {
                        if let accessToken = dictionary["access_token"] as? String {
                            // access individual value in dictionary
                            completion(accessToken, nil)
                        }
                        else {
                            if let message = dictionary["message"] as? String {
                                completion(nil, ServiceError.ServerMessage(message))
                            }
                            else {
                                completion(nil, ServiceError.TokenNotFound)
                            }
                        }
                    }
                    else {
                        completion(nil, ServiceError.TokenNotFound)
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }).resume()
    }
    
    func GoogleLogin(from url : URL, token : String, completion: @escaping (String?, Error?) -> Void){
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
         // Parse JSON and print in console
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    if let dictionary = json as? [String: Any] {
                        if let accessToken = dictionary["access_token"] as? String {
                            // access individual value in dictionary
                            completion(accessToken, nil)
                        }
                        else {
                            if let message = dictionary["message"] as? String {
                                completion(nil, ServiceError.ServerMessage(message))
                            }
                            else {
                                completion(nil, ServiceError.TokenNotFound)
                            }
                        }
                    }
                    else {
                        completion(nil, ServiceError.TokenNotFound)
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }else {
                completion(nil, error)
            }
        }).resume()
    }
}
