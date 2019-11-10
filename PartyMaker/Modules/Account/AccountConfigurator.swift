//
//  AccountConfigurator.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class AccountConfigurator : AccountConfiguratorProtocol {
    func configure(with viewController: AccountViewController) {
        let presenter = AccountPresenter(view: viewController)
        let interactor = AccountInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
    }
}
