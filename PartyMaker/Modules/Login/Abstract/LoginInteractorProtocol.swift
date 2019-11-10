//
//  LoginInteractorProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol LoginInteractorProtocol : class {
    var emailValue: String { set get }
    var passwordValue: String { set get }
    func login(completion: @escaping(PresenterStatus, String?)->Void)
    func googleLogin(token : String, completion: @escaping (PresenterStatus, String?) -> Void)
    func getCurrentUser()
}
