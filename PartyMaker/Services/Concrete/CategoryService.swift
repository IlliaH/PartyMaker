//
//  CategoryService.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-23.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class CategoryService : CategoryServiceProtocol {
    
    func getAgeCategories(completion: @escaping ([AgeCategory]?, Error?) -> Void) {
        
        guard let url = URL(string: "http://partymakerbhm.azurewebsites.net/api/Category/age") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let ageCategories = try jsonDecoder.decode([AgeCategory].self, from: data)
                    completion(ageCategories, nil)
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
        
    }
    
    func getEventTypes(completion: @escaping ([EventType]?, Error?) -> Void) {
        
        guard let url = URL(string: "http://partymakerbhm.azurewebsites.net/api/Category/eventType") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let eventTypes = try jsonDecoder.decode([EventType].self, from: data)
                    completion(eventTypes, nil)
                } catch {
                    completion(nil, error)
                    print(error)
                }
            }else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
        
    }
    
}
