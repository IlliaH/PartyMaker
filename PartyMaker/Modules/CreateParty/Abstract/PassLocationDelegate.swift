//
//  PassLocationProtocol.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-01.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol PassLocationDelegate {
    func passEventLocation(latitude : Decimal, longitude : Decimal, address: String)
}
