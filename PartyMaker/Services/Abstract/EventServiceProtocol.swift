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
    func getEvents(completion: @escaping([EventShort]?, Error?) -> Void)
    func getEventById(id: Int, completion: @escaping(Event?, Error?) -> Void)
    func getUserEvents(completion: @escaping([EventShort]?, Error?) -> Void)
    func getFollowedEvents(completion: @escaping([EventShort]?, Error?) -> Void)
    
    func followEvent(id: Int, completion: @escaping(Error?) -> Void)
    func unfollowEvent(id: Int, completion: @escaping(Error?) -> Void)
    
    func createEventInvitations(id: Int, invitations: [EventInvitation], completion: @escaping([EventInvitation]?, Error?) -> Void)
    func joinPrivateEvent(code: String, completion: @escaping(Event?, Error?) -> Void)
}
