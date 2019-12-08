//
//  CreatePartyInteractor.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class CreatePartyInteractor : CreatePartyInteractorProtocol {

    weak var presenter: CreatePartyPresenterProtocol!
    
    var event: Event = Event()
    
    var hashtags: String?
    
    var pictureValue: Data?
    
    let eventService : EventServiceProtocol = EventService()
    let categoryService : CategoryServiceProtocol = CategoryService()
    let storageService: StorageService = StorageService()
    
    required init(presenter: CreatePartyPresenterProtocol) {
        self.presenter = presenter
    }
    
    func create(completion: @escaping (PresenterStatus, String?) -> Void) {
        eventService.createEvent(event: event) { (event, error) in
            if let error = error {
                completion(PresenterStatus.CreateEventError, error.localizedDescription)
            }else if event == nil{
                completion(PresenterStatus.CreateEventError, "Event has not been saved")
            } else {
                if let picture = self.pictureValue {
                    self.storageService.uploadFile(picture: picture) { (pictureUrl, error) in
                        if error != nil {
                            completion(PresenterStatus.Sucess, "Event created without image")
                        }
                        else if let pictureUrl = pictureUrl {
                            event!.pictureUrl = pictureUrl
                            self.eventService.updateEvent(event: event!) { (updatedEvent, error) in
                                if let error = error {
                                    completion(PresenterStatus.CreateEventError, error.localizedDescription)
                                }
                                else if updatedEvent == nil {
                                    completion(PresenterStatus.CreateEventError, "Event has not been updated")
                                }
                                else {
                                    completion(PresenterStatus.Sucess, "Event created")
                                }
                            }
                        }
                    }
                }
                else {
                    completion(PresenterStatus.Sucess, "Event created")
                }
            }
        }
    }
    
    func getEventTypes(completion: @escaping (PresenterStatus, [EventType]?) -> Void) {
        categoryService.getEventTypes { (eventTypes, error) in
            if let error = error {
                completion(PresenterStatus.GetEventsError, nil)
            }else if eventTypes == nil{
                completion(PresenterStatus.GetEventsError, nil)
            } else {
                completion(PresenterStatus.Sucess, eventTypes)
            }
        }
    }
       
    func getAgeCategories(completion: @escaping (PresenterStatus, [AgeCategory]?) -> Void) {
        categoryService.getAgeCategories { (ageCategories, error) in
            if let error = error {
                completion(PresenterStatus.GetAgeCategoriesError, nil)
            }else if ageCategories == nil{
                completion(PresenterStatus.GetAgeCategoriesError, nil)
            } else {
                completion(PresenterStatus.Sucess, ageCategories)
            }
        }
    }
}
