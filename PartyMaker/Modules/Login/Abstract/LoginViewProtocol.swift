//
//  LoginViewProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol LoginViewProtocol : class {
    func showLoader()
    func hideLoader()
    func showAlert(title : String, message: String)
}
