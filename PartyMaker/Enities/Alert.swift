//
//  Alert.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-10.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertButton)
        return alert
    }
}
