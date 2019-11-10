//
//  AccountInteractor.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

class AccountInteractor : AccountInteractorProtocol {
    weak var presenter : AccountPresenterProtocol!
    
    var nicknameValue: String = ""
    var emailValue: String = ""
    var oldPasswordValue: String = ""
    var newPasswordConfirmValue: String = ""
    var pictureValue: Data?
    var isPasswordChanged: Bool = false
    
    let userService : UserServiceProtocol = UserService()
    let storageService : StorageServiceProtocol = StorageService()
    
    required init(presenter: AccountPresenterProtocol) {
        self.presenter = presenter
    }
    

    func updateProfile(completion: @escaping (PresenterStatus, String?) -> Void) {
        guard let nickname = AppDelegate.currentUser?.nickname, let email = AppDelegate.currentUser?.email, let userPhotoUrl = AppDelegate.currentUser?.pictureUrl else {return}
        
        if !nickname.elementsEqual(nicknameValue) || !email.elementsEqual(emailValue) || pictureValue != nil {
            if pictureValue != nil {
                storageService.uploadFile(picture: pictureValue!) { (pictureUrl, error) in
                    if let pictureURL = pictureUrl {
                        self.userService.update(email: self.emailValue, nickname: self.nicknameValue, pictureUrl: pictureURL) { (error) in
                            if let error = error {
                                completion(.UploadPictureError, error.localizedDescription)
                            } else {
                                completion(.Sucess, "User updated successfully")
                            }
                        }
                    }
                }
            } else {
                
                userService.update(email: emailValue, nickname: nicknameValue, pictureUrl: userPhotoUrl) { (error) in
                    if let error = error {
                        completion(.UpdateUserError, error.localizedDescription)
                    } else {
                        completion(.Sucess, "User has been updated")
                    }
                }
            }
            
        }
        
        if isPasswordChanged {
            userService.updatePassword(newPassword: newPasswordConfirmValue, oldPassword: oldPasswordValue) { (error) in
                if let error = error {
                    completion(.UpdatePasswordError, error.localizedDescription)
                } else {
                    completion(.Sucess, "Password has been updated successfully")
                }
            }
        }
    }
    
}
