//
//  AgeCategory.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-23.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class AgeCategory : Codable, Equatable {
    
    static func == (lhs: AgeCategory, rhs: AgeCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    var id : Int?
    var name : String?
}
