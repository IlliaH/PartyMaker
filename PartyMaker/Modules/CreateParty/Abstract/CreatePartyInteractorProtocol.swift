//
//  CreatePartyInteractorProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/18/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol CreatePartyInteractorProtocol : class {
    var event: Event { set get }
    var hashtags: String? { set get }
    var pictureValue: Data? { set get }
    
    func create(completion: @escaping(PresenterStatus, String?) ->Void)
    func getEventTypes(completion :@escaping(PresenterStatus, [EventType]?)->Void)
    func getAgeCategories(completion: @escaping(PresenterStatus, [AgeCategory]?)-> Void)
}
