//
//  RegisterRouter.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class RegisterRouter : RegisterRouterProtocol {
    weak var viewController: RegisterController!
    
    init(viewController: RegisterController) {
        self.viewController = viewController
    }
    
    func showMainView() {
        print("Navigated to main view")
    }
}
