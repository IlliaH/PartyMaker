//
//  CreatePartyViewProtocol.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/23/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation

protocol CreatePartyViewProtocol: class {
    func showLoader()
    func hideLoader()
    
    func showStartCalendar()
    func hideStartCalendar()
    
    func showEndCalendar()
    func hideEndCalendar()
    func showAlert(title : String, message: String)
    
    func showAgeCategoryPicker(data: [[String]])
    func hideAgeCategoryPicker()
    func presentView()
    
    func showEventTypePicker(data: [[String]])
    func hideEventTypePicker()
}
