//
//  User.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class User : Codable {
    let id : Int?
    let firstName : String?
    let lastName : String?
    let email : String?
    let nickname : String?
    let pictureUrl : String?
    let eventCounter : Int?
}
