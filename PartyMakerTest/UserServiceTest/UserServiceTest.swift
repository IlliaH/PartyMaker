//
//  UserServiceTest.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-03.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
@testable import PartyMaker

class UserServiceTest {
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func register(from url : URL, nickname: String, firstName: String, lastName: String, email: String, password: String, passwordConfirm: String, completion: @escaping (Error?) -> Void) {
        
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [String : Any] else {return completion(nil)}
                if let message = dictionary["message"]{
                    completion(error)
                }else {
                    completion(nil)
                }
            }else {
                completion(ServiceError.NoResponseFromServer)
            }
         
        }).resume()
    }
    
    
    func update(from url : URL, email: String, nickname: String, pictureUrl: String, completion: @escaping (Error?) -> Void) {
        
        let json: [String: Any] = ["Email" : email, "Nickname" : nickname, "PictureUrl" : pictureUrl]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
            
         // Parse JSON and print in console
            if let data = data {
               let json = try! JSONSerialization.jsonObject(with: data, options: [])
               guard let dictionary = json as? [String : Any] else {return completion(nil)}
               if let message = dictionary["message"]{
                   completion(error)
               }else {
                   completion(nil)
               }
            }else {
                completion(ServiceError.NoResponseFromServer)
            }
        }).resume()
    }
    
    
    func updatePassword(from url : URL, newPassword: String, oldPassword: String, completion: @escaping (Error?) -> Void) {
    let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
        // Parse JSON and print in console
            if let data = data {
               let json = try! JSONSerialization.jsonObject(with: data, options: [])
               guard let dictionary = json as? [String : Any] else {return completion(nil)}
               if let message = dictionary["message"]{
                   completion(error)
               }else {
                   completion(nil)
               }
            }else {
                completion(ServiceError.NoResponseFromServer)
            }
        }).resume()
        
    }
    
    
    func getCurrentUser(from url : URL, completion: @escaping (User?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: {(data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(User.self, from: data)
                    completion(user, nil)
                } catch {
                    completion(nil, error)
                    print(error)
                }
                
            } else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
            
        }).resume()
    }
    
}

