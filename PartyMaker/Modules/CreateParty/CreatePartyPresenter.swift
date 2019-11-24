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
    
    func showStartCalendarClicked() {
        view.showStartCalendar()
    }
    
    func showEndCalendarClicked() {
        view.showEndCalendar()
    }
    
    func showAgeCategoryPickerClicked() {
        // TO DO: get categories from server
        let ageCategoriesData: [[String]] = [["Teenagers", "Students", "Adults", "Seniors"]]
        
        view.showAgeCategoryPicker(data: ageCategoriesData)
    }
    
    func showEventTypePickerClicked() {
        // TO DO: get categories from server
        let eventTypeData: [[String]] = [["Birthday", "Cocktail", "Dances and balls", "Block", "Showers"]]
        
        view.showEventTypePicker(data: eventTypeData)
    }
    
    func createButonClicked() {
        view.showLoader()
        interactor.create { (status, message) in
            // TO DO: handle status
            self.view.hideLoader()
            print(status)
            print(message as Any)
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
        // TO DO: implement age category
    }
    
    func eventTypeValueChanged(to newEventType: String?) {
        // TO DO: implement event types
    }
    
    func numberOfPeopleChanged(to newNumberOfPeople: String?) {
        numberOfPeopleValue = newNumberOfPeople
    }
    
    func pictureValueChanged(to newPictureValue: UIImage?) {
        pictureValue = newPictureValue
    }
}
