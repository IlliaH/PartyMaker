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
import DateTimePicker

class EventDetailsViewController: UIViewController, EventDetailsViewControllerProtocol {
    
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    @IBOutlet weak var startDateSelectButton: UIButton!
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    @IBOutlet weak var endDateSelectButton: UIButton!
    @IBOutlet weak var photoImageView: RoundImageView!
    @IBOutlet weak var partyNameTextField: CustomHoshiTextField!
    @IBOutlet weak var partyDescriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: CustomHoshiTextField!
    @IBOutlet weak var addressSelectButton: UIButton!
    @IBOutlet weak var ageCategoryTextField: CustomHoshiTextField!
    @IBOutlet weak var eventTypeTextField: CustomHoshiTextField!
    @IBOutlet weak var participantsSlider: Slider!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var startdateTimePicker: DateTimePicker?
    var enddateTimePicker: DateTimePicker?
    
    var event : Event?
    var loader : FillableLoader?
    let eventService : EventServiceProtocol = EventService()
    var eventId : Int?
    let categoryService : CategoryServiceProtocol = CategoryService()
    let storageService: StorageServiceProtocol = StorageService()
    
    let dateFormatter = ISO8601DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.formatOptions =  [
        .withYear,
        .withMonth,
        .withDay,
        .withTime,
        .withDashSeparatorInDate,
        .withColonSeparatorInTime]
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
        
        guard let name = event.name, let startDate = event.startDate, let endDate = event.endDate, let description = event.description, let ageCategoryId = event.ageCategoryId, let eventTypeId = event.eventTypeId, let numberOfPeople = event.numberOfPeople, let latitude = event.latitude, let longitude = event.longitude else {return}
        
        if let eventPicture = event.picture{
           photoImageView.image = UIImage(data: eventPicture)
        }
        
        partyNameTextField.text = name
        
        if let startDateValue = dateFormatter.date(from: startDate) {
            startDateTextField.text = startDateValue.shortDateTime
        }
        else {
            startDateTextField.text = startDate
        }
        
        if let endDateValue = dateFormatter.date(from: endDate) {
            endDateTextField.text = endDateValue.shortDateTime
        }
        else {
            endDateTextField.text = endDate
        }
        
        partyDescriptionTextView.text = description
        loadFluidSlider(with: numberOfPeople)
        
        setAddressFromCoordinate(latitude: latitude, longitude: longitude)
        setAgeCategory(id: ageCategoryId)
        setEventCategory(id: eventTypeId)
        
        if event.isUserEvent == true {
            configureControlsForAuthor()
        }
        
        if event.isFollowedEvent == true {
            followButton.setTitle("Unfollow", for: .normal)
        }
    }
    
    func configureControlsForAuthor() {
        followButton.isHidden = true
        saveButton.isHidden = false
        photoImageView.isUserInteractionEnabled = true
        startDateSelectButton.isHidden = false
        endDateSelectButton.isHidden = false
        partyDescriptionTextView.isUserInteractionEnabled = true
        addressSelectButton.isHidden = false
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
    
    func setAgeCategory(id : Int){
        categoryService.getAgeCategories { (ageCategories, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.ageCategoryTextField.text = "Unable to show category"
                }
            } else if ageCategories != nil{
                let ageCategory = ageCategories?.first(where: { (ageCategory) -> Bool in
                    ageCategory.id == id
                })
                DispatchQueue.main.async {
                    self.ageCategoryTextField.text = ageCategory?.name
                }
            }
        }
    }
    
    func setEventCategory(id : Int){
        categoryService.getEventTypes { (eventTypes, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.eventTypeTextField.text = "Unable to show category"
                }
            } else if eventTypes != nil {
                let eventType = eventTypes?.first(where: { (eventType) -> Bool in
                    eventType.id == id
                })
                DispatchQueue.main.async {
                    self.eventTypeTextField.text = eventType?.name
                }
            }
        }
    }
    
    @IBAction func pictureOnTouch(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) { }
    }
    
    @IBAction func saveChangesButtonOnTapped(_ sender: UIButton) {
        guard let event = event else { return }
        
        if let startDate = startDateTextField.text {
            event.startDate = startDate
        }else {
            let alert = Alert.createAlert(title: "Attention", message: "Start date filed shold not be blank")
            self.present(alert, animated: true, completion: nil)
        }
        
        if let endDate = endDateTextField.text {
            event.endDate = endDate
        } else {
            let alert = Alert.createAlert(title: "Attention", message: "End date filed shold not be blank")
            self.present(alert, animated: true, completion: nil)
        }
        
        if let description = partyDescriptionTextView.text {
            if description.isNotEmpty {
                event.description = description
                
                if let photoImageData = photoImageView.image?.pngData(), photoImageData != event.picture {
                    showLoader()
                    storageService.uploadFile(picture: photoImageData) { (imageUrl, error) in
                        self.hideLoader()
                        if error != nil {
                            DispatchQueue.main.async {
                                let alert = Alert.createAlert(title: "Error", message: "Picture has not been updated")
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else if let imageUrl = imageUrl {
                            self.event?.pictureUrl = imageUrl
                            self.updateEvent()
                        }
                    }
                }
                else {
                    updateEvent()
                }
            } else {
                let alert = Alert.createAlert(title: "Attention", message: "Add description to your event")
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = Alert.createAlert(title: "Attention", message: "Add description to your event")
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateEvent() {
        guard let event = event else { return }
        
        showLoader()
        eventService.updateEvent(event: event) { (updatedEvent, error) in
            self.hideLoader()
            if let error = error {
                 DispatchQueue.main.async {
                    let alert = Alert.createAlert(title: "Error", message: "Picture has not been updated")
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else if let updatedEvent = updatedEvent {
                // Alert success
            }
        }
    }
    
    @IBAction func followEventButtonOnTapped(_ sender: UIButton) {
        guard let event = event, let eventId = event.id else { return }
        
        showLoader()
        if event.isFollowedEvent == true {
            eventService.unfollowEvent(id: eventId, completion: { (error) in
                self.hideLoader()
                if error == nil {
                    self.event?.isFollowedEvent = false
                    DispatchQueue.main.async {
                        self.followButton.setTitle("Follow", for: .normal)
                    }
                }
            })
        }
        else {
            eventService.followEvent(id: eventId, completion: { (error) in
                self.hideLoader()
                if error == nil {
                    self.event?.isFollowedEvent = true
                    DispatchQueue.main.async {
                        self.followButton.setTitle("Unfollow", for: .normal)
                    }
                }
            })
        }
    }
    
    @IBAction func selectDateOnTouch(_ sender: UIButton) {
        // Tag 0 = start date
        if sender.tag == 0 {
            showStartCalendar()
        }
        // Tag 1 = end date
        else if sender.tag == 1 {
            showEndCalendar()
        }
    }
    
    func showStartCalendar() {
        guard let startdateTimePicker = startdateTimePicker else {
            self.startdateTimePicker = createAndReturnDate(min: Date(), max: Date().addingTimeInterval(60 * 60 * 24 * 4 * 12 * 6), textField: startDateTextField)
            self.startdateTimePicker?.dismissHandler = hideStartCalendar
            return
        }
        
        self.view.addSubview(startdateTimePicker)
    }
    
    func hideStartCalendar() {
        startdateTimePicker?.removeFromSuperview()
    }
    
    func showEndCalendar() {
        guard let enddateTimePicker = enddateTimePicker else {
            var minDate = Date()
            
            if let event = event, let startDate = event.startDate,
                let startDateValue = dateFormatter.date(from: startDate) {
                minDate = startDateValue
            }
            
            self.enddateTimePicker = createAndReturnDate(min: minDate, max: Date().addingTimeInterval(60 * 60 * 24 * 4 * 12 * 6), selectedDate: minDate, textField: endDateTextField)
            self.enddateTimePicker?.dismissHandler = hideEndCalendar
            return
        }
        
        self.view.addSubview(enddateTimePicker)
    }
    
    func hideEndCalendar() {
        enddateTimePicker?.removeFromSuperview()
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
    
    func createAndReturnDate(min: Date?, max: Date?, selectedDate: Date = Date(), textField: UITextField) -> DateTimePicker {
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        let size = self.view.bounds.size.height - picker.frame.size.height - tabBarHeight
        
        picker.frame = CGRect(x: 0, y: size, width: picker.frame.size.width, height: picker.frame.size.height)
        let formatString: String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current)!
        picker.is12HourFormat = formatString.contains("a")
        picker.includeMonth = true
        picker.dateFormat = DateFormatter.dateFormat(fromTemplate: "hh:mm a YYYY-MM-dd", options: 0, locale: .current)!
        picker.highlightColor = UIColor.init(named: "MainColor") ?? UIColor.cyan
        picker.darkColor = UIColor.black
        picker.doneBackgroundColor = UIColor.init(named: "MainColor") ?? UIColor.gray
        
        picker.completionHandler = { date in
            print(date.shortDateTime)
            textField.text = date.shortDateTime
        }
        self.view.addSubview(picker)
        
        picker.selectedDate = selectedDate
        
        return picker
    }
    
    @IBAction func onScreenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension EventDetailsViewController : PassLocationDelegate {
    func passEventLocation(latitude: Decimal, longitude: Decimal, address: String) {
        event?.latitude = latitude
        event?.longitude = longitude
        addressTextField.text = address
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDetailsToSelectAddressSegue" {
            let selectAddressVC = segue.destination as! SelectAddressViewController
            selectAddressVC.delegate = self
        }
    }
}

extension EventDetailsViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Implementation of UIImagePickerDelegate. This function triggers when user has selected an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Use guard let to get a reference to selected image
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        // Save a reference to that image
        photoImageView.image = photo
        // Dismiss UIImagePickerController
        self.dismiss(animated: true)
    }
}
