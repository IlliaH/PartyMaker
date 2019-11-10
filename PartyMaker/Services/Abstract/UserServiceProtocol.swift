//
//  RegisterServiceProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    func register(nickname: String, firstName: String, lastName: String, email: String, password: String, passwordConfirm: String, completion: @escaping(Error?)->Void)
    func update(email: String, nickname: String, pictureUrl: String, completion: @escaping(Error?)->Void)
    func updatePassword(newPassword : String, oldPassword : String, completion: @escaping(Error?)-> Void)
    func getCurrentUser(completion: @escaping(User?, Error?)->Void)
}
