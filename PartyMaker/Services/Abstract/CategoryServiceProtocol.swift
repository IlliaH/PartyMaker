//
//  CategoryServiceProtocol.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-23.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol CategoryServiceProtocol : class {
    func getAgeCategories(completion: @escaping([AgeCategory]?, Error?)->Void)
    func getEventTypes(completion: @escaping([EventType]?, Error?)->Void)
}
