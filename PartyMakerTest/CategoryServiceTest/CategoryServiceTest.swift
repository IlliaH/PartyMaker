//
//  CategoryServiceTest.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-03.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
@testable import PartyMaker

class CategoryServiceTest {
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func getAgeCategories(from url : URL, completion: @escaping ([AgeCategory]?, Error?) -> Void) {
        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let ageCategories = try jsonDecoder.decode([AgeCategory].self, from: data)
                    completion(ageCategories, nil)
                } catch {
                    print(error)
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }.resume()
        
    }
    
    func getEventTypes(from url : URL, completion: @escaping ([EventType]?, Error?) -> Void) {
        let task = session.dataTask(with: url) { (data, _, error) in
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

