//
//  AuthService.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-12.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class AuthService : AuthServiceProtocol {
   let userService = UserService()
    
    func Login(email: String, password: String, remember_me: Bool, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)auth/login") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "email=\(email)&password=\(password)&remember_me=\(remember_me)".data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let response = response {
                print(response)
            }
            
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
            }
        }).resume()
    }
    
    func GoogleLogin(token : String, completion: @escaping (String?, Error?) -> Void){
        guard let url = URL(string: "\(AppConstant.API_URL)auth/logingoogle") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "token=\(token)".data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let response = response {
                print(response)
            }
            
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
            }
        }).resume()
    }
    
}
