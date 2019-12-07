//
//  PhoneContact.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class PhoneContact {
    
    var contactName : String?
    var contactNumber : String?
    var isChecked = false
    
    init(contactName : String, contactNumber : String) {
        self.contactName = contactName
        self.contactNumber = contactNumber
    }
    
}
