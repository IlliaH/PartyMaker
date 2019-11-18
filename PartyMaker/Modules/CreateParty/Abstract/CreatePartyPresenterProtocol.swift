//
//  CreatePartyPresenterProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

protocol CreatePartyPresenterProtocol : class {
    var router: CreatePartyRouterProtocol! { set get }
    
    func showStartCalendarClicked()
    func showEndCalendarClicked()
    
    func showAgeCategoryPickerClicked()
    func showEventTypePickerClicked()
    
    func createButonClicked()
    
    func nameValueChanged(to newNameValue: String?)
    func descriptionValueChanged(to newDescriptionValue: String?)
    func hashtagsValueChanged(to newHashtagsValue: String?)
    func startDateValueChanged(to newStartDateValue: Date?)
    func endDateValueChanged(to newEndDateValue: Date?)
    func isPrivateValueChanged(to newIsPrivateValue: Bool)
    func ageCategoryValueChanged(to newAgeCategory: String?)
    func eventTypeValueChanged(to newEventType: String?)
    func numberOfPeopleChanged(to newNumberOfPeople: String?)
    func pictureValueChanged(to newPictureValue: UIImage?)
}
