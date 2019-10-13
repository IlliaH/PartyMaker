//
//  AppError.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-12.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

enum ServiceError : Error {
    case TokenNotFound
    case ServerMessage(String)
}
