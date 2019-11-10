//
//  LoginPresenter.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class LoginPresenter : LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol!
    var interactor: LoginInteractorProtocol!
    var router: LoginRouterProtocol!
    
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
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
    
    func emailValueChanged(to newEmailValue: String?) {
        emailValue = newEmailValue
    }
    
    func passwordValueChanged(to newPasswordValue: String?) {
        passwordValue = newPasswordValue
    }
    
    func loginButtonClicked() {
        view.showLoader()
        interactor.login { (status, message) in
            if (status == .Sucess) {
                self.router.showMainView()
                self.interactor.getCurrentUser()
                self.view.hideLoader()
            }
            else if (status == .LoginError) {
                print(message as Any)
                self.view.hideLoader()
            }
        }
    }
    
    func googleLoginButtonClicked(tokenID : String) {
        interactor.googleLogin(token: tokenID, completion: { (status, message) in
            if (status == .Sucess) {
                self.router.showMainView()
            }
            else if (status == .LoginError) {
                print(message as Any)
            }
        })
    }
    
    
}
