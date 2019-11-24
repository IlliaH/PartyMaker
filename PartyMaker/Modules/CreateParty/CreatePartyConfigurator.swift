//
//  CreatePartyConfigurator.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class CreatePartyConfigurator: CreatePartyConfiguratorProtocol {
    func configure(with viewController: CreatePartyViewController) {
        let presenter = CreatePartyPresenter(view: viewController)
        let interactor = CreatePartyInteractor(presenter: presenter)
        let router = CreatePartyRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
