//
//  EventDetailsViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import fluid_slider
import CoreLocation
import MapKit

class EventDetailsViewController: UIViewController, EventDetailsViewControllerProtocol {
    
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    @IBOutlet weak var photoImageView: RoundImageView!
    @IBOutlet weak var partyNameTextField: CustomHoshiTextField!
    @IBOutlet weak var partyDescriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: CustomHoshiTextField!
    @IBOutlet weak var ageCategoryTextField: CustomHoshiTextField!
    @IBOutlet weak var eventTypeTextField: CustomHoshiTextField!
    @IBOutlet weak var participantsSlider: Slider!
    
    var event : Event?
    var loader : FillableLoader?
    let eventService : EventServiceProtocol = EventService()
    var eventId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getEventById()
    }
    
    func loadFluidSlider(with currentValue : Int) {
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
            participantsSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            // string shows current value
            let string = formatter.string(from: (currentValue) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
    }
            
        participantsSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
        participantsSlider.setMaximumLabelAttributedText(NSAttributedString(string: "100", attributes: labelTextAttributes))
            participantsSlider.fraction = 0.5
            participantsSlider.shadowOffset = CGSize(width: 0, height: 10)
            participantsSlider.shadowBlur = 5
            participantsSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
            participantsSlider.contentViewColor = UIColor(named: "MainColor")
            participantsSlider.valueViewColor = .white
    }
    
    func getEventById() {
        guard let id = eventId else {return}
        showLoader()
        eventService.getEventById(id: id) { (event, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let event = event {
                self.event = event
                DispatchQueue.main.async {
                    self.assignValuesToControls()
                }
            }
            self.hideLoader()
        }
    }
    
    func assignValuesToControls() {
        guard let event = event else {return}
        
        guard let name = event.name, let startDate = event.startDate, let endDate = event.endDate, let description = event.description, let ageCategoryId = event.ageCategoryId, let eventType = event.eventTypeId, let numberOfPeople = event.numberOfPeople, let latitude = event.latitude, let longitude = event.longitude else {return}
        
        partyNameTextField.text = name
        startDateTextField.text = startDate
        endDateTextField.text = endDate
        partyDescriptionTextView.text = description
        // photoImageView.image = UIImage(data: picture)
        loadFluidSlider(with: numberOfPeople)
        
        setAddressFromCoordinate(latitude: latitude, longitude: longitude)
    }
    
    func setAddressFromCoordinate(latitude : Decimal, longitude : Decimal){
        var point : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat = (latitude as NSNumber).doubleValue
        let long = (longitude as NSNumber).doubleValue
        point.latitude = lat
        point.longitude = long
        
        let location : CLLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        reverseGeoLocation(location: location) { (result, error) in
            if let error = error {
                self.addressTextField.text = "Unable to retrieve address"
            } else {
                self.addressTextField.text = result
            }
        }
    }
    
    func reverseGeoLocation(location : CLLocation, completion: @escaping(String?, Error?)-> Void){
        let geo : CLGeocoder = CLGeocoder()
        geo.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("reverse geocode fail : \(error?.localizedDescription)")
                completion(nil, error)
            }
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let location = placemarks![0]
                let city = location.locality
                let landmark = location.subLocality
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
                print(addressString)
                completion(addressString, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    @IBAction func sendInvitationButtonOnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func saveChangesButtonOnTapped(_ sender: UIButton) {
        
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.loader = WavesLoader.createLoader(with: LoaderPath.glassPath(), on: self.view)
            guard let loader = self.loader else {return}
                   loader.loaderColor = UIColor.systemPink
                   loader.showLoader()
        }
       }
       
       func hideLoader() {
        DispatchQueue.main.async {
            guard let loader = self.loader else {return}
        loader.removeLoader()
       }
    }
    
}
