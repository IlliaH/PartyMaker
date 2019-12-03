//
//  User.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class User : Codable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.email == rhs.email && lhs.nickname == rhs.nickname && lhs.pictureUrl == rhs.pictureUrl && lhs.eventCounter == rhs.eventCounter
    }
    
    var id : Int?
    var firstName : String?
    var lastName : String?
    var email : String?
    var nickname : String?
    var pictureUrl : String?
    var eventCounter : Int?
}
