//
//  RegisterPresenter.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class RegisterPresenter : RegisterPresenterProtocol {
    
    weak var view: RegisterViewProtocol!
    var interactor: RegisterInteractorProtocol!
    var router: RegisterRouterProtocol!
    
    var nicknameValue: String? {
        willSet(newNicknameValue) {
            if let nickname = newNicknameValue {
                if (interactor.nicknameValue != nickname) {
                    interactor.nicknameValue = nickname
                }
            }
        }
    }
    
    var firstNameValue: String? {
        willSet(newFirstNameValue) {
            if let firstName = newFirstNameValue {
                if (interactor.firstNameValue != firstName) {
                    interactor.firstNameValue = firstName
                }
            }
        }
    }
    
    var lastNameValue: String? {
        willSet(newLastNameValue) {
            if let lastName = newLastNameValue {
                if (interactor.lastNameValue != lastName) {
                    interactor.lastNameValue = lastName
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
    
    var passwordValue: String? {
        willSet(newPasswordValue) {
            if let password = newPasswordValue {
                if (interactor.passwordValue != password) {
                    interactor.passwordValue = password
                }
            }
        }
    }
    
    var passwordConfirmValue: String? {
        willSet(newPasswordConfirmValue) {
            if let passwordConfirm = newPasswordConfirmValue {
                if (interactor.passwordConfirmValue != passwordConfirm) {
                    interactor.passwordConfirmValue = passwordConfirm
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
    
    func registerButtonClicked() {
        view.showLoader()
        interactor.register { (status, message) in
            if status == .Sucess {
                self.router.showMainView()
                self.view.hideLoader()
            }
            else if status == .RegisterPictureUploadError {
                // Alert picture upload failed
                print("Picture upload failed")
                self.router.showMainView()
                self.view.hideLoader()
            }
            else if status == .RegisterError {
                print(message as Any)
                self.view.hideLoader()
            }
        }
    }
    
    required init(view: RegisterViewProtocol) {
        self.view = view
    }
    
    func nicknameValueChanged(to newNicknameValue: String?) {
        nicknameValue = newNicknameValue
    }
    
    func firstNameValueChanged(to newFirstNameValue: String?) {
        firstNameValue = newFirstNameValue
    }
    
    func lastNameValueChanged(to newLastNameValue: String?) {
        lastNameValue = newLastNameValue
    }
    
    func emailValueChanged(to newEmailValue: String?) {
        emailValue = newEmailValue
    }
    
    func passwordValueChanged(to newPasswordValue: String?) {
        passwordValue = newPasswordValue
    }
    
    func passwordConfirmValueChanged(to newPasswordConfirmValue: String?) {
        passwordConfirmValue = newPasswordConfirmValue
    }
    
    func pictureValueChanged(to newPictureValue: UIImage?) {
        pictureValue = newPictureValue
    }
    
    
}
