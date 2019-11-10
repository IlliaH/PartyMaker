//
//  AccountInteractorProtocol.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol AccountInteractorProtocol : class {
       var nicknameValue: String { set get }
       var emailValue: String { set get }
       var oldPasswordValue: String { set get }
       var newPasswordConfirmValue: String { set get }
       var pictureValue: Data? { set get }
       var isPasswordChanged : Bool {set get}
       func updateProfile(completion: @escaping(PresenterStatus, String?)->Void)
}
