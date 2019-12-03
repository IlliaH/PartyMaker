//
//  EventShort.swift
//  PartyMaker
//
//  Created by 8teRnity on 12/2/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class EventShort : Codable {
    var id : Int?
    var name: String?
    var latitude: Decimal?
    var longitude: Decimal?
    var pictureUrl: String?
    var picture: Data?
}
