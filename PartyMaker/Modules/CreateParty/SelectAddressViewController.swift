//
//  SelectAddressViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-01.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SelectAddressViewController: MapBaseViewController {

    @IBOutlet weak var pinImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    var delegate : PassLocationDelegate?
    
    @IBAction func selectLocationButtonOnTapped(_ sender: UIButton) {
        let center = getCenterLocation(for: mapView)
        let latitude : Decimal = Decimal(center.coordinate.latitude)
        let longitude : Decimal = Decimal(center.coordinate.longitude)
        delegate?.passEventLocation(latitude: latitude, longitude: longitude, address: addressLabel.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectAddressViewController : MKMapViewDelegate {
    // keep track of center, any time it changes I use that coordinate and put in label
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else {return}
        
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center, completionHandler: {[weak self] (placemarks, error) in
            guard let self = self else {return}
            if let _ = error {
                //TODO: show alert informing the user
                return
            }
            guard let placemark = placemarks?.first else {
                // TODO: show alert informing the user
                return
            }
            
            let location = placemarks![0]
            let city = location.locality
            let streetAddress = location.thoroughfare
            let postalCode = location.postalCode
            
            var addressString : String = ""
            if city != nil {
                addressString += city! + ","
            }
            if streetAddress != nil {
                addressString += streetAddress! + ","
            }
            if postalCode != nil {
                addressString += postalCode! + " "
            }
            
            DispatchQueue.main.async {
                self.addressLabel.text = addressString
            }
        })
    
    }
}
