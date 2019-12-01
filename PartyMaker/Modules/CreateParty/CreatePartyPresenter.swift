//
//  CreatePartyPresenter.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class CreatePartyPresenter: CreatePartyPresenterProtocol {
    weak var view: CreatePartyViewProtocol!
    var interactor: CreatePartyInteractorProtocol!
    var router: CreatePartyRouterProtocol!
    
    var eventTypes : [EventType]?
    var ageCategories : [AgeCategory]?
    var isLoading : Bool = false {
        willSet(newNameValue) {
            if newNameValue {
                view.showLoader()
            } else {
                view.hideLoader()
            }
        }
    }
    let dateFormatter = ISO8601DateFormatter()
    
    var nameValue: String? {
        willSet(newNameValue) {
            if let name = newNameValue {
                if interactor.event.Name != name {
                    interactor.event.Name = name
                }
            }
        }
    }
    
    var ageCategoryValue: String? {
        willSet(newNameValue) {
            guard let categories = ageCategories else {return}
            let categoryId = categories.firstIndex {$0.name == newNameValue}
            guard let unwrappedId = categoryId else { return }
            let selectedCategory = categories[unwrappedId]
            let selectedCategoryId = selectedCategory.id
            interactor.event.AgeCategoryId = selectedCategoryId
        }
    }
    
    var eventTypeValue: String? {
        willSet(newNameValue) {
            guard let eventTypes = eventTypes else {return}
            let eventTypeId = eventTypes.firstIndex {$0.name == newNameValue}
            guard let unwrappedId = eventTypeId else { return }
            let selectedEventType = eventTypes[unwrappedId]
            let selectedEventTypeId = selectedEventType.id
            interactor.event.EventTypeId = selectedEventTypeId
        }
    }
    
    var descriptionValue: String? {
        willSet(newDescriptionValue) {
            if let description = newDescriptionValue {
                if interactor.event.Description != description {
                    interactor.event.Description = description
                }
            }
        }
    }
    
    var hashtagsValue: String? {
        willSet(newHashtagsValue) {
            if let hashtags = newHashtagsValue {
                if interactor.hashtags != hashtags {
                    interactor.hashtags = hashtags
                }
            }
        }
    }
    
    var startDateValue: Date? {
        willSet(newStartDateValue) {
            if let startDateValue = newStartDateValue {
                let dateValue = dateFormatter.string(from: startDateValue)
                
                if interactor.event.StartDate != dateValue {
                    interactor.event.StartDate = dateValue
                }
            }
        }
    }
    
    var endDateValue: Date? {
        willSet(newEndDateValue) {
            if let endDateValue = newEndDateValue {
                let dateValue = dateFormatter.string(from: endDateValue)
                
                if interactor.event.EndDate != dateValue {
                    interactor.event.EndDate = dateValue
                }
            }
        }
    }
    
    var isPrivateValue: Bool? {
        willSet(newIsPrivateValue) {
            if interactor.event.IsPrivate != newIsPrivateValue {
                interactor.event.IsPrivate = newIsPrivateValue
            }
        }
    }
    
    var numberOfPeopleValue: String? {
        willSet(newNumberOfPeopleValue) {
            if let numberOfPeopleValue = newNumberOfPeopleValue {
                if let numberOfPeople = Int(numberOfPeopleValue) {
                    if interactor.event.NumberOfPeople != numberOfPeople {
                        interactor.event.NumberOfPeople = numberOfPeople
                    }
                }
            }
        }
    }
    
    var pictureValue: UIImage? {
        willSet(newImageValue) {
            if let image = newImageValue {
                if let imageData = image.pngData() {
                    if interactor.pictureValue != imageData {
                        interactor.pictureValue = imageData
                    }
                }
            }
        }
    }
    
    var latitudeValue: Decimal? {
        willSet(newLatitudeValue) {
            if let latitude = newLatitudeValue {
                if interactor.event.Latitude != latitude {
                    interactor.event.Latitude = latitude
                }
            }
        }
    }
    
    var longitudeValue: Decimal? {
        willSet(newLongitudeValue) {
            if let longitude = newLongitudeValue {
                if interactor.event.Longitude != longitude {
                    interactor.event.Longitude = longitude
                }
            }
        }
    }
    
    func showStartCalendarClicked() {
        view.showStartCalendar()
    }
    
    func showEndCalendarClicked() {
        view.showEndCalendar()
    }
    
    func showAgeCategoryPickerClicked() {
        // TO DO: get categories from server
        //let ageCategoriesData: [[String]] = [["Teenagers", "Students", "Adults", "Seniors"]]
        
        if isLoading {
            return
        } else {
            isLoading = true
            if let ageCategories = self.ageCategories {
                let ageCategoryNames : [String] = ageCategories.map {$0.name ?? "Unknown"}
                self.isLoading = false
                self.view.showAgeCategoryPicker(data: [ageCategoryNames])
            }else {
                interactor.getAgeCategories { (status, ageCategories) in
                    if status == PresenterStatus.Sucess {
                        // Alert, use router to redirect user
                        guard let categories = ageCategories else { return }
                        self.ageCategories = categories
                        let ageCategoriesNames : [String] = categories.map {$0.name ?? "Unknown"}
                        self.isLoading = false
                        self.view.showAgeCategoryPicker(data: [ageCategoriesNames])
                    } else if status == PresenterStatus.GetAgeCategoriesError {
                        // Alert
                        self.isLoading = false
                    }
                }
            }
        }
        
        
    }
    
    func showEventTypePickerClicked() {
        // let eventTypeData: [[String]] = [["Birthday", "Cocktail", "Dances and balls", "Block", "Showers"]]
        // TO DO: get categories from server
        
        if isLoading {
            return
        } else {
            isLoading = true
            if let eventTypes = self.eventTypes {
                let eventTypeNames : [String] = eventTypes.map {$0.name ?? "Unknown"}
                self.isLoading = false
                self.view.showEventTypePicker(data: [eventTypeNames])
            }else {
                interactor.getEventTypes { (status, eventTypes) in
                    if status == PresenterStatus.Sucess {
                        // Alert, use router to redirect user
                        guard let types = eventTypes else { return }
                        self.eventTypes = types
                        let eventTypeNames : [String] = types.map {$0.name ?? "Unknown"}
                        self.isLoading = false
                        self.view.showEventTypePicker(data: [eventTypeNames])
                    } else if status == PresenterStatus.GetEventsError {
                        // Alert
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func createButonClicked() {
        view.showLoader()
        interactor.create { (status, message) in
            // TO DO: handle status
            self.view.hideLoader()
            if status == PresenterStatus.Sucess {
                // Alert, use router to redirect user
                print(message)
            } else if status == PresenterStatus.CreateEventError {
                print(message)
            }
        }
    }
    
    required init(view: CreatePartyViewProtocol) {
        self.view = view
    }
    
    func nameValueChanged(to newNameValue: String?) {
        nameValue = newNameValue
    }
    
    func descriptionValueChanged(to newDescriptionValue: String?) {
        descriptionValue = newDescriptionValue
    }
    
    func hashtagsValueChanged(to newHashtagsValue: String?) {
        hashtagsValue = newHashtagsValue
    }
    
    func startDateValueChanged(to newStartDateValue: Date?) {
        startDateValue = newStartDateValue
    }
    
    func endDateValueChanged(to newEndDateValue: Date?) {
        endDateValue = newEndDateValue
    }
    
    func isPrivateValueChanged(to newIsPrivateValue: Bool) {
        isPrivateValue = newIsPrivateValue
    }
    
    func ageCategoryValueChanged(to newAgeCategory: String?) {
        ageCategoryValue = newAgeCategory
    }
    
    func eventTypeValueChanged(to newEventType: String?) {
        eventTypeValue = newEventType
    }
    
    func numberOfPeopleChanged(to newNumberOfPeople: String?) {
        numberOfPeopleValue = newNumberOfPeople
    }
    
    func pictureValueChanged(to newPictureValue: UIImage?) {
        pictureValue = newPictureValue
    }
    
    func latitudeValueChanged(to newLatitudeValue: Decimal?) {
        latitudeValue = newLatitudeValue
    }
    
    func longitudeValueChanged(to newLongitudeValue: Decimal?) {
        longitudeValue = newLongitudeValue
    }
}
