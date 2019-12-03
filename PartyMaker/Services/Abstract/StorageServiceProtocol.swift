//
//  StorageServiceProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 10/21/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol StorageServiceProtocol {
    func uploadFile(picture: Data, completion: @escaping(String?, Error?)->Void)
    func downloadFile(url: String, completion: @escaping(Data?, Error?)->Void)
}
