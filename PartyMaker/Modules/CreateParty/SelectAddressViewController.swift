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

class SelectAddressViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    var delegate : PassLocationDelegate?
    
    let locationManager = CLLocationManager()
    let regionInMeters : Double = 10000
    var previousLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationService()
    }

    func setupLocationManager(){
        locationManager.delegate = self 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // check location to be enabled
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting the user know they have to turn this on
        }
    }
    
    // display accurate user location on the map
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
            break
        case .denied:
            // show alert instructing how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alret letting them now what`s up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView)-> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    @IBAction func selectLocationButtonOnTapped(_ sender: UIButton) {
        let center = getCenterLocation(for: mapView)
        let latitude : Decimal = Decimal(center.coordinate.latitude)
        let longitude : Decimal = Decimal(center.coordinate.longitude)
        delegate?.passEventLocation(latitude: latitude, longitude: longitude)
        dismiss(animated: true, completion: nil)
    }
    
}


extension SelectAddressViewController : CLLocationManagerDelegate{
    // triggers when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
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
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        })
    
    }
}
