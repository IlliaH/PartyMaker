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
    
    var isPasswordChangedSwitchValue : Bool? {
        willSet(newSwitchValue) {
            if let value = newSwitchValue {
                interactor.isPasswordChanged = value
            }
        }
    }
    
    required init(view: AccountViewProtocol) {
        self.view = view
    }
    
    func editPassword(isPasswordChanged: Bool) {
        interactor.isPasswordChanged = isPasswordChanged
        isPasswordChangedSwitchValue = isPasswordChanged
        if isPasswordChanged {
            view.showPassword()
        } else {
            view.hidePassword()
        }
    }
    
    
    func saveButtonClicked() {
        
        if isPasswordChangedSwitchValue == true {
                if let nickname = nicknameValue, let email = emailValue, let picture = pictureValue, let oldPassword = oldPasswordValue, let newPassword = newPasswordValue {
                    
                    if nickname.isNotEmpty && email.isNotEmpty && oldPassword.isNotEmpty && newPassword.isNotEmpty {
                        
                        if oldPassword != newPassword {
                            performRequest()
                        } else {
                            view.showAlert(title: "Attention", message: "All fields should be filled!")
                        }
                    } else {
                        view.showAlert(title: "Attention", message: "All fields should be filled!")
                    }
                    
                } else {
                    view.showAlert(title: "Attention", message: "All fields should be filled!")
                }
            } else {
            if let nickname = nicknameValue, let email = emailValue, let picture = pictureValue {
                if nickname.isNotEmpty && email.isNotEmpty {
                    performRequest()
                } else {
                    view.showAlert(title: "Attention", message: "All fields should be filled!")
                }
            } else {
                view.showAlert(title: "Attention", message: "All fields should be filled!")
            }

            }
    
    }
    
    func performRequest() {
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
                self.view.showAlert(title: "Error", message: "Picture upload failed")
            }
            else if status == .UpdateUserError {
                print(message as Any)
                self.view.hideLoader()
                self.view.showAlert(title: "Error", message: "User has not been updated")
            } else if status == .UpdatePasswordError {
                print("Password could not be changed")
                self.view.hideLoader()
                self.view.showAlert(title: "Error", message: "Password has not been changed")
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
