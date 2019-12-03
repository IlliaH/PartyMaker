//
//  EventService.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class EventService: EventServiceProtocol {
    let storageService: StorageService = StorageService()
    
    func createEvent(event: Event, completion: @escaping (Event?, Error?) -> Void) {
        
        guard let url = URL(string: "\(AppConstant.API_URL)Event") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return}
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let data : [String : Any] = ["Name" : event.Name, "Description" : event.Description, "StartDate" : event.StartDate, "EndDate" : event.EndDate, "PictureUrl" : event.PictureUrl, "Latitude" : event.Latitude, "Longitude" : event.Longitude, "IsPrivate" : event.IsPrivate, "AgeCategoryId" : event.AgeCategoryId, "EventTypeId" : event.EventTypeId, "NumberOfPeople" : event.NumberOfPeople]
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
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
                            if response.statusCode == 201 {
                                do {
                                    let jsonDecoder = JSONDecoder()
                                    let event = try jsonDecoder.decode(Event.self, from: data)
                                     completion(event, nil)
                                } catch {
                                    print(error)
                                    completion(nil, error)
                                }
                            }else {
                                if let message = dictionary["message"] as? String {
                                    completion(nil, ServiceError.ServerMessage(message))
                                   print(message)
                                }
                                else {
                                    completion(nil, ServiceError.NoResponseFromServer)
                                }
                            }
                        } else {
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
    
    func updateEvent(event: Event, completion: @escaping (Event?, Error?) -> Void) {
        
    }
    
    func getEvents(completion: @escaping ([EventShort]?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)Event") else {return}
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
                    let events = try jsonDecoder.decode([EventShort].self, from: data)
                    
                    // Download images
                    var eventsCounter = events.count
                    for event in events {
                        if let pictureUrl = event.pictureUrl {
                            self.storageService.downloadFile(url: pictureUrl) { (data, _) in
                                event.picture = data
                                eventsCounter -= 1
                                
                                if eventsCounter == 0 {
                                    completion(events, nil)
                                }
                            }
                        } else {
                            eventsCounter -= 1
                            if eventsCounter == 0 {
                                completion(events, nil)
                            }
                        }
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
}
