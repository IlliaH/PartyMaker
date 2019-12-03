//
//  Event.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class Event : Codable, Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.Id == rhs.Id && lhs.Name == rhs.Name && lhs.Description == rhs.Description && lhs.StartDate == rhs.StartDate && lhs.EndDate == rhs.EndDate && lhs.PictureUrl == rhs.PictureUrl && lhs.Latitude == rhs.Latitude && lhs.Longitude == rhs.Longitude && lhs.IsPrivate == rhs.IsPrivate && lhs.AgeCategoryId == rhs.AgeCategoryId && lhs.EventTypeId == rhs.EventTypeId && lhs.NumberOfPeople == rhs.NumberOfPeople
    }
    
    var Id: Int?
    var Name: String?
    var Description: String?
    var StartDate: String?
    var EndDate: String?
    var PictureUrl: String?
    var Latitude: Decimal?
    var Longitude: Decimal?
    var IsPrivate: Bool?
    var AgeCategoryId: Int?
    var EventTypeId: Int?
    var NumberOfPeople: Int?
}
