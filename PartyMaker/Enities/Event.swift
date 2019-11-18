//
//  Event.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class Event : Codable {
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
