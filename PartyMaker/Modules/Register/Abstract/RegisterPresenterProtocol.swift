//
//  RegisterPresenterProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterPresenterProtocol : class {
    var router: RegisterRouterProtocol! { set get }
    func registerButtonClicked()
    func nicknameValueChanged(to newNicknameValue: String?)
    func firstNameValueChanged(to newFirstNameValue: String?)
    func lastNameValueChanged(to newLastNameValue: String?)
    func emailValueChanged(to newEmailValue: String?)
    func passwordValueChanged(to newPasswordValue: String?)
    func passwordConfirmValueChanged(to newPasswordConfirmValue: String?)
    func pictureValueChanged(to newPictureValue: UIImage?)
}
