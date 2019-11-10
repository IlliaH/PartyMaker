//
//  RegisterService.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class UserService : UserServiceProtocol {
    func register(nickname: String, firstName: String, lastName: String, email: String, password: String, passwordConfirm: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)auth/signup") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "nickName=\(nickname)&firstName=\(firstName)&lastName=\(lastName)&email=\(email)&password=\(password)&passwordConfirm=\(passwordConfirm)".data(using: .utf8)
        
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
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode == 201 {
                                completion(nil)
                            }
                            else {
                                if let message = dictionary["message"] as? String {
                                    completion(ServiceError.ServerMessage(message))
                                }
                                else {
                                    completion(ServiceError.NoResponseFromServer)
                                }
                            }
                        }
                    }
                    else {
                        completion(ServiceError.NoResponseFromServer)
                    }
                } catch {
                    print(error)
                    completion(error)
                }
            }
        }).resume()
    }
    
    func update(email: String, nickname: String, pictureUrl: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)auth/user") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let json: [String: Any] = ["Email" : email, "Nickname" : nickname, "PictureUrl" : pictureUrl]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
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
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode == 202 {
                                completion(nil)
                            }
                            else {
                                if let message = dictionary["message"] as? String {
                                    completion(ServiceError.ServerMessage(message))
                                }
                                else {
                                    completion(ServiceError.NoResponseFromServer)
                                }
                            }
                        }
                    }
                    else {
                        completion(ServiceError.NoResponseFromServer)
                    }
                } catch {
                    print(error)
                    completion(error)
                }
            }
        }).resume()
    }
    
    
    
    func updatePassword(newPassword: String, oldPassword: String, completion: @escaping (Error?) -> Void) {
        
        guard let url = URL(string: "\(AppConstant.API_URL)auth/user/password") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "password=\(newPassword)&oldPassword=\(oldPassword)".data(using: .utf8)
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                            if let response = response as? HTTPURLResponse {
                                if response.statusCode == 202 {
                                    completion(nil)
                                }
                                else {
                                    if let message = dictionary["message"] as? String {
                                        completion(ServiceError.ServerMessage(message))
                                    }
                                    else {
                                        completion(ServiceError.NoResponseFromServer)
                                    }
                                }
                            }
                        }
                        else {
                            completion(ServiceError.NoResponseFromServer)
                        }
                    } catch {
                        print(error)
                        completion(error)
                    }
                }
            }).resume()
            
        }
    
    
    
    func getCurrentUser(completion: @escaping (User?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)auth/user") else {return}
        var request = URLRequest(url: url)
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
       // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let response = response {
                print(response)
            }
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
