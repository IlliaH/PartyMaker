//
//  AccountPresenter.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

protocol AccountPresenterProtocol : class {
    func saveButtonClicked()
    func nicknameValueChanged(to newNicknameValue: String?)
    func emailValueChanged(to newEmailValue: String?)
    func oldPasswordValueChanged(to newPasswordValue: String?)
    func newPasswordConfirmValueChanged(to newPasswordConfirmValue: String?)
    func pictureValueChanged(to newPictureValue: UIImage?)
    func editPassword(isPasswordChanged : Bool)
    func performRequest()
}
