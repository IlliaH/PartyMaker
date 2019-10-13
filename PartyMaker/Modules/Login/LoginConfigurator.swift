//
//  LoginConfigurator.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class LoginConfigurator : LoginConfiguratorProtocol {
    func configure(with viewController: LoginController) {
        let presenter = LoginPresenter(view: viewController)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
