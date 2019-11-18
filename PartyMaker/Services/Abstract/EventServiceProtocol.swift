//
//  EventServiceProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol EventServiceProtocol {
    func createEvent(event: Event, completion: @escaping(Event?, Error?) -> Void)
    func updateEvent(event: Event, completion: @escaping(Event?, Error?) -> Void)
}
