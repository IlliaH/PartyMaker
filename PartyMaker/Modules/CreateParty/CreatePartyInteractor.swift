//
//  CreatePartyInteractor.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class CreatePartyInteractor : CreatePartyInteractorProtocol {
    weak var presenter: CreatePartyPresenterProtocol!
    
    var event: Event = Event()
    
    var hashtags: String?
    
    var pictureValue: Data?
    
    required init(presenter: CreatePartyPresenterProtocol) {
        self.presenter = presenter
    }
    
    func create(completion: @escaping (PresenterStatus, String?) -> Void) {
        
    }
}
