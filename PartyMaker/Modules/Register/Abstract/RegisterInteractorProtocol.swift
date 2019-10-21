//
//  RegisterInteractorProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol RegisterInteractorProtocol : class {
    var nicknameValue: String { set get }
    var firstNameValue: String { set get }
    var lastNameValue: String { set get }
    var emailValue: String { set get }
    var passwordValue: String { set get }
    var passwordConfirmValue: String { set get }
    var pictureValue: Data? { set get }
    func register(completion: @escaping(PresenterStatus, String?)->Void)
}
