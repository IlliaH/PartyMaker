//
//  EventDetailsViewControllerProtocol.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-08.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import CoreLocation

protocol EventDetailsViewControllerProtocol {
    func assignValuesToControls()
    func loadFluidSlider(with currentValue : Int)
    func reverseGeoLocation(location : CLLocation, completion: @escaping(String?, Error?)-> Void)
    func showLoader()
    func hideLoader()
}
