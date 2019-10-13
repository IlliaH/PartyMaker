//
//  LoginInteractor.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/12/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginPresenterProtocol!
    
    var emailValue: String = ""
    
    var passwordValue: String = ""
    
    let authService: AuthServiceProtocol = AuthService()
    
    required init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
    
    func login(completion: @escaping (PresenterStatus, String?) -> Void) {
        authService.Login(email: emailValue, password: passwordValue, remember_me: false) { (accessToken, error) in
            if let error = error {
                completion(.LoginError, error.localizedDescription)
            }
            else if accessToken == nil || accessToken == "" {
                completion(.LoginError, "Token is invalid")
            }
            else {
                // Save access token
                print(accessToken)
                completion(.Sucess, "Token received successfully")
            }
        }
    }
    
    func googleLogin(token : String, completion: @escaping (PresenterStatus, String?) -> Void){
        authService.GoogleLogin(token: token, completion: {
            (accessToken, error) in
            if let error = error {
                completion(.LoginError, error.localizedDescription)
            }
            else if accessToken == nil || accessToken == "" {
                 completion(.LoginError, "Token is invalid")
            }
            else {
                // Save access token
                print(accessToken)
                completion(.Sucess, "Token received successfully")
            }
        })
    }
    
    
}
