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
        
         let data : [String : Any] = ["Name" : event.name as Any, "Description" : event.description as Any, "StartDate" : event.startDate as Any, "EndDate" : event.endDate as Any, "PictureUrl" : event.pictureUrl as Any, "Latitude" : event.latitude as Any, "Longitude" : event.longitude as Any, "IsPrivate" : event.isPrivate as Any, "AgeCategoryId" : event.ageCategoryId as Any, "EventTypeId" : event.eventTypeId as Any, "NumberOfPeople" : event.numberOfPeople as Any]
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
        guard let eventId = event.id else { completion(nil, ServiceError.InvalidParameters); return }
        guard let url = URL(string: "\(AppConstant.API_URL)Event/\(eventId)") else { completion(nil, ServiceError.InvalidParameters); return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { completion(nil, ServiceError.TokenNotFound); return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let data : [String : Any] = ["Name" : event.name as Any, "Description" : event.description as Any, "StartDate" : event.startDate as Any, "EndDate" : event.endDate as Any, "PictureUrl" : event.pictureUrl as Any, "Latitude" : event.latitude as Any, "Longitude" : event.longitude as Any, "IsPrivate" : event.isPrivate as Any, "AgeCategoryId" : event.ageCategoryId as Any, "EventTypeId" : event.eventTypeId as Any, "NumberOfPeople" : event.numberOfPeople as Any, "Id": eventId as Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    completion(nil, ServiceError.PageNotFound)
                }
                else if response.statusCode == 202 {
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let event = try jsonDecoder.decode(Event.self, from: data)
                            
                            if let pictureUrl = event.pictureUrl {
                                self.storageService.downloadFile(url: pictureUrl) { (data, _) in
                                    event.picture = data
                                        
                                    completion(event, nil)
                                }
                            } else {
                                completion(event, nil)
                            }
                        } catch {
                            print(error)
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ServiceError.NoResponseFromServer)
                    }
                }
                else {
                    completion(nil, ServiceError.NoResponseFromServer)
                }
            }
            else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
    
    func getEvents(completion: @escaping ([EventShort]?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)Event") else {completion(nil, ServiceError.InvalidParameters); return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {completion(nil, ServiceError.TokenNotFound); return}
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
    
    func getEventById(id: Int, completion: @escaping (Event?, Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)Event/\(id)") else {completion(nil, ServiceError.InvalidParameters); return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {completion(nil, ServiceError.TokenNotFound); return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    completion(nil, ServiceError.PageNotFound)
                }
                else if response.statusCode == 200 {
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let event = try jsonDecoder.decode(Event.self, from: data)
                            
                            if let pictureUrl = event.pictureUrl {
                                self.storageService.downloadFile(url: pictureUrl) { (data, _) in
                                    event.picture = data
                                        
                                    completion(event, nil)
                                }
                            } else {
                                completion(event, nil)
                            }
                        } catch {
                            print(error)
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ServiceError.NoResponseFromServer)
                    }
                }
                else {
                    completion(nil, ServiceError.NoResponseFromServer)
                }
            }
            else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
    
    func followEvent(id: Int, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)Event/\(id)/follow") else { completion(ServiceError.InvalidParameters); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { completion(ServiceError.TokenNotFound); return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    completion(ServiceError.PageNotFound)
                }
                else if response.statusCode == 200 {
                    completion(nil)
                }
                else {
                    completion(ServiceError.NoResponseFromServer)
                }
            }
            else {
                completion(ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
    
    func unfollowEvent(id: Int, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(AppConstant.API_URL)Event/\(id)/unfollow") else { completion(ServiceError.InvalidParameters); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { completion(ServiceError.TokenNotFound); return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    completion(ServiceError.PageNotFound)
                }
                else if response.statusCode == 200 {
                    completion(nil)
                }
                else {
                    completion(ServiceError.NoResponseFromServer)
                }
            }
            else {
                completion(ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
    
    func joinPrivateEvent(code: String, completion: @escaping (Event?, Error?) -> Void) {
        if code.isEmpty {
            completion(nil, ServiceError.InvalidParameters)
            return
        }
        
        guard let url = URL(string: "\(AppConstant.API_URL)Event/joinPrivateEvent/\(code)") else { completion(nil, ServiceError.InvalidParameters); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { completion(nil, ServiceError.TokenNotFound); return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    completion(nil, ServiceError.PageNotFound)
                }
                else if response.statusCode == 201 {
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let event = try jsonDecoder.decode(Event.self, from: data)
                            
                            if let pictureUrl = event.pictureUrl {
                                self.storageService.downloadFile(url: pictureUrl) { (data, _) in
                                    event.picture = data
                                        
                                    completion(event, nil)
                                }
                            } else {
                                completion(event, nil)
                            }
                        } catch {
                            print(error)
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ServiceError.NoResponseFromServer)
                    }
                }
                else {
                    completion(nil, ServiceError.NoResponseFromServer)
                }
            }
            else {
                completion(nil, ServiceError.NoResponseFromServer)
            }
        }.resume()
    }
}
