//
//  LoginRouter.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class LoginRouter : LoginRouterProtocol {
    weak var viewController: LoginController!
    
    init(viewController: LoginController) {
        self.viewController = viewController
    }
    
    func showMainView() {
        print("Navigated to main VC")
    }
    
    func showRegisterView() {
        viewController.performSegue(withIdentifier: "LoginToRegisterSegue", sender: nil)
    }
}
