//
//  AppError.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-12.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

enum ServiceError : LocalizedError {
    case TokenNotFound
    case ServerMessage(String)
    case NoResponseFromServer
    
    var errorDescription: String? {
        switch self {
        case let .ServerMessage(message):
            return message
        case .TokenNotFound:
            return "Token was not found in response"
        case .NoResponseFromServer:
            return "Server is not available"
        }
    }
}
