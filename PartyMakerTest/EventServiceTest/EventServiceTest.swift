//
//  NetworkManager.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-02.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
@testable import PartyMaker

class EventServiceTest {
    
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func getEvents(from url : URL, completion: @escaping ([EventShort]?, Error?) -> Void) {
        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let events = try jsonDecoder.decode([EventShort].self, from: data)
                    
                    completion(events, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
    
    func createEvent(from url: URL, event: Event, completion: @escaping (Event?, Error?) -> Void) {
        
        let data : [String : Any] = ["Name" : event.Name, "Description" : event.Description, "StartDate" : event.StartDate, "EndDate" : event.EndDate, "PictureUrl" : event.PictureUrl, "Latitude" : event.Latitude, "Longitude" : event.Longitude, "IsPrivate" : event.IsPrivate, "AgeCategoryId" : event.AgeCategoryId, "EventTypeId" : event.EventTypeId, "NumberOfPeople" : event.NumberOfPeople]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [String:Any] else {return completion(nil, error)}
                
                if let message = dictionary["message"]{
                    print("message")
                    completion(nil, error)
                } else {
                    let jsonDecoder = JSONDecoder()
                    let event = try! jsonDecoder.decode(Event.self, from: data)
                    print("correct request")
                    completion(event, nil)
                }
                
            }else {
                print("data is nil")
                completion(nil, error)
            }
            
        }.resume()
    }
    
}

