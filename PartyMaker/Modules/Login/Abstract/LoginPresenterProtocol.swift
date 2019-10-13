//
//  LoginPresenterProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol : class {
    var router: LoginRouterProtocol! { set get }
    func loginButtonClicked()
    func emailValueChanged(to newEmailValue: String?)
    func passwordValueChanged(to newPasswordValue: String?)
}
