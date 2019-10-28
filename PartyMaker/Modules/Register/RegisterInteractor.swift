//
//  RegisterInteractor.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class RegisterInteractor : RegisterInteractorProtocol {
    weak var presenter: RegisterPresenterProtocol!
    
    var nicknameValue: String = ""
    
    var firstNameValue: String = ""
    
    var lastNameValue: String = ""
    
    var emailValue: String = ""
    
    var passwordValue: String = ""
    
    var passwordConfirmValue: String = ""
    
    var pictureValue: Data?
    
    let userService: UserServiceProtocol = UserService()
    let authService: AuthServiceProtocol = AuthService()
    let storageService: StorageServiceProtocol = StorageService()
    
    required init(presenter: RegisterPresenterProtocol) {
        self.presenter = presenter
    }
    
    func register(completion: @escaping (PresenterStatus, String?) -> Void) {
        userService.register(nickname: nicknameValue, firstName: firstNameValue, lastName: lastNameValue, email: emailValue, password: passwordValue, passwordConfirm: passwordConfirmValue) { (error) in
            if let error = error {
                completion(.RegisterError, error.localizedDescription)
            }
            else {
                self.authService.Login(email: self.emailValue, password: self.passwordValue, remember_me: false) { (accessToken, error) in
                    
                    if let error = error {
                        completion(.LoginError, error.localizedDescription)
                    }
                    else if accessToken == nil || accessToken == "" {
                        completion(.LoginError, "Token is invalid")
                    }
                    else {
                        // Save access token
                        print(accessToken)
                        UserDefaults.standard.set("\(accessToken)", forKey: "accessToken")
                        
                        if let picture = self.pictureValue {
                            self.storageService.uploadFile(picture: picture) { (pictureUrl, error) in
                                if let error = error {
                                    completion(.RegisterPictureUploadError, error.localizedDescription)
                                }
                                else if pictureUrl == nil || pictureUrl == "" {
                                    completion(.RegisterPictureUploadError, "Picture url is invalid")
                                }
                                else {
                                    self.userService.update(email: self.emailValue, nickname: self.nicknameValue, pictureUrl: pictureUrl!) { (error) in
                                        if let error = error {
                                            completion(.RegisterPictureUploadError, error.localizedDescription)
                                        }
                                        else {
                                            completion(.Sucess, "User registered successfully")
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            completion(.Sucess, "User registered successfully")
                        }
                    }
                }
            }
        }
    }
}
