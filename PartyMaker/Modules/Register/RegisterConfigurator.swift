//
//  RegisterConfigurator.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class RegisterConfigurator : RegisterConfiguratorProtocol {
    func configure(with viewController: RegisterController) {
        let presenter = RegisterPresenter(view: viewController)
        let interactor = RegisterInteractor(presenter: presenter)
        let router = RegisterRouter(viewController: viewController)
               
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
