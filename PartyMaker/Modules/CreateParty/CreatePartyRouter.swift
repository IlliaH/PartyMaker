//
//  CreatePartyRouter.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class CreatePartyRouter: CreatePartyRouterProtocol {
    weak var viewController: CreatePartyViewController!
    
    init(viewController: CreatePartyViewController) {
        self.viewController = viewController
    }
    
    func changeScreenToMap() {
        guard let view = viewController else {return}
        view.presentView()
    }
    
}
