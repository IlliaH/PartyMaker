//
//  AccountPresenter.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class AccountPresenter : AccountPresenterProtocol {
    
    
    weak var view: AccountViewProtocol!
    var interactor : AccountInteractorProtocol!
    
    var nicknameValue: String? {
        willSet(newNicknameValue) {
            if let nickname = newNicknameValue {
                if (interactor.nicknameValue != nickname) {
                    interactor.nicknameValue = nickname
                }
            }
        }
    }
    
    var oldPasswordValue: String? {
        willSet(newOldPasswordValue) {
            if let password = newOldPasswordValue {
                if (interactor.oldPasswordValue != password) {
                    interactor.oldPasswordValue = password
                }
            }
        }
    }
    
    var newPasswordValue: String? {
        willSet(newPasswordValue) {
            if let newPassword = newPasswordValue {
                if (interactor.newPasswordConfirmValue != newPassword) {
                    interactor.newPasswordConfirmValue = newPassword
                }
            }
        }
    }
    
    var emailValue: String? {
        willSet(newEmailValue) {
            if let email = newEmailValue {
                if (interactor.emailValue != email) {
                    interactor.emailValue = email
                }
            }
        }
    }
    
    var pictureValue: UIImage? {
        willSet(newImageValue) {
            if let image = newImageValue {
                if let imageData = image.pngData() {
                    if interactor.pictureValue != imageData {
                        interactor.pictureValue = imageData
                    }
                }
            }
        }
    }
    
    required init(view: AccountViewProtocol) {
        self.view = view
    }
    
    func editPassword(isPasswordChanged: Bool) {
        interactor.isPasswordChanged = isPasswordChanged
        if isPasswordChanged {
            view.showPassword()
        } else {
            view.hidePassword()
        }
    }
    
    
    func saveButtonClicked() {
        view.showLoader()
        interactor.updateProfile { (status, message) in
            if status == .Sucess {
                // call success alert
                self.view.hideLoader()
            }
            else if status == .UploadPictureError {
                // Alert picture upload failed
                print("Picture upload failed")
                self.view.hideLoader()
            }
            else if status == .UpdateUserError {
                print(message as Any)
                self.view.hideLoader()
            } else if status == .UpdatePasswordError {
                print("Password could not be changed")
                self.view.hideLoader()
            }
        }
    }
    
    
    
    func nicknameValueChanged(to newNicknameValue: String?) {
        nicknameValue = newNicknameValue
    }
    
    func emailValueChanged(to newEmailValue: String?) {
        emailValue = newEmailValue
    }
    
    func oldPasswordValueChanged(to newPasswordValue: String?) {
        oldPasswordValue = newPasswordValue
    }
    
    func newPasswordConfirmValueChanged(to newPasswordConfirmValue: String?) {
        newPasswordValue = newPasswordConfirmValue
    }
    
    func pictureValueChanged(to newPictureValue: UIImage?) {
        pictureValue = newPictureValue
    }
    
    
}
