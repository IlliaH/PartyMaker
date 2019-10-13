//
//  AuthService.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-12.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol AuthServiceProtocol {
    func Login(email : String, password : String, remember_me : Bool, completion: @escaping(String?, Error?)->Void)
    
    func GoogleLogin(token : String, completion: @escaping(String?, Error?)->Void)
}
