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
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.pictureUrl == rhs.pictureUrl && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.isPrivate == rhs.isPrivate && lhs.ageCategoryId == rhs.ageCategoryId && lhs.eventTypeId == rhs.eventTypeId && lhs.numberOfPeople == rhs.numberOfPeople
    }
    
    var id: Int?
    var name: String?
    var description: String?
    var startDate: String?
    var endDate: String?
    var pictureUrl: String?
    var picture: Data?
    var latitude: Decimal?
    var longitude: Decimal?
    var isPrivate: Bool?
    var ageCategoryId: Int?
    var eventTypeId: Int?
    var numberOfPeople: Int?
    var isUserEvent : Bool?
    var isFollowedEvent : Bool?
}
