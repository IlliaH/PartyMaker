//
//  CreatePartyViewController.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/16/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import DateTimePicker
import McPicker

class CreatePartyViewController: UIViewController {
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    
    @IBOutlet weak var ageCategoryTextField: CustomHoshiTextField!
    
    @IBOutlet weak var eventTypeTextField: CustomHoshiTextField!
    
    @IBOutlet weak var logoImageView: RoundImageView!
    
    var startdateTimePicker: DateTimePicker?
    var enddateTimePicker: DateTimePicker?
    
    var ageCategoryPicker: McPicker?
    var eventTypePicker: McPicker?
    
    var loader : FillableLoader?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func selectStartDateOnTouch(_ sender: UIButton) {
        // Tag 0 = start date
        if sender.tag == 0 {
            showStartCalendar()
        }
        // Tag 1 = end date
        else if sender.tag == 1 {
            showEndCalendar()
        }
        
    }
    
    @IBAction func pickerOnTouch(_ sender: UIButton) {
        let ageCategoriesData: [[String]] = [["Teenagers", "Students", "Adults", "Seniors"]]
        let eventTypeData: [[String]] = [["Birthday", "Cocktail", "Dances and balls", "Block", "Showers"]]
        
        if sender.tag == 0 {
            showAgeCategoryPicker(data: ageCategoriesData)
        }
        else if sender.tag == 1 {
            showEventTypePicker(data: eventTypeData)
        }
        
    }
    
    @IBAction func pictureOnTouch(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) { }
    }
    
    func createAndReturnDate(min: Date?, max: Date?, selectedDate: Date = Date(), textField: UITextField) -> DateTimePicker {
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        let size = self.view.bounds.size.height - picker.frame.size.height - tabBarHeight
        
        picker.frame = CGRect(x: 0, y: size, width: picker.frame.size.width, height: picker.frame.size.height)
        picker.is12HourFormat = true
        picker.includeMonth = true
        picker.dateFormat = "hh:mm a YYYY-MM-dd"
        picker.highlightColor = UIColor.init(named: "MainColor") ?? UIColor.cyan
        picker.darkColor = UIColor.black
        picker.doneBackgroundColor = UIColor.init(named: "MainColor") ?? UIColor.gray
        
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a YYYY-MM-dd"
            print(formatter.string(from: date))
            textField.text = formatter.string(from: date)
        }
        self.view.addSubview(picker)
        
        picker.selectedDate = selectedDate
        
        return picker
    }
    
    func createAndReturnPickerView(data: [[String]]) -> McPicker{
        let mcPicker = McPicker(data: data)

        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = .red
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!
        mcPicker.label = customLabel // Set your custom label
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Select") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])

        mcPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!

        mcPicker.toolbarButtonsColor = .red
        mcPicker.toolbarBarTintColor = .lightGray
        mcPicker.pickerBackgroundColor = .lightText
        mcPicker.backgroundColor = .black
        mcPicker.backgroundColorAlpha = 0.15
        
        return mcPicker
    }
    
    func setValuesForPickerAndTextField( picker: inout McPicker?, data: [[String]], textField: UITextField) {
        guard let pickerValue = picker, let textFieldText = textField.text else {
            picker = createAndReturnPickerView(data: data)
            
            picker?.pickerSelectRowsForComponents = [
                0: [0: true]
            ]
            
            picker?.show { (selections: [Int : String]) in
                if let category = selections[0] {
                    textField.text = category
                }
            }
            
            return
        }
        
        let index = data[0].lastIndex(of: textFieldText) ?? 0
        
        pickerValue.pickerSelectRowsForComponents = [
            0: [index: true]
        ]
        
        pickerValue.show { (selections: [Int : String]) in
            if let category = selections[0] {
                textField.text = category
            }
        }
    }
}

extension CreatePartyViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Implementation of UIImagePickerDelegate. This function triggers when user has selected an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Use guard let to get a reference to selected image
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        // Save a reference to that image
        logoImageView.image = photo
        // Dismiss UIImagePickerController
        self.dismiss(animated: true)
    }
}

extension CreatePartyViewController : CreatePartyViewProtocol {
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
        if startdateTimePicker?.selectedDate == nil {
            // Alert
            print("select start date")
        }
        else {
            guard let enddateTimePicker = enddateTimePicker else {
                let minDate = startdateTimePicker?.selectedDate.addingTimeInterval(60 * 60 * 2) ?? Date()
                self.enddateTimePicker = createAndReturnDate(min: minDate, max: Date().addingTimeInterval(60 * 60 * 24 * 4 * 12 * 6), selectedDate: minDate, textField: endDateTextField)
                self.enddateTimePicker?.dismissHandler = hideEndCalendar
                return
            }
            
            self.view.addSubview(enddateTimePicker)
        }
    }
    
    func hideEndCalendar() {
        enddateTimePicker?.removeFromSuperview()
    }
    
    func showAgeCategoryPicker(data: [[String]]) {
        setValuesForPickerAndTextField(picker: &ageCategoryPicker, data: data, textField: ageCategoryTextField)
    }
    
    func hideAgeCategoryPicker() {
        ageCategoryPicker?.removeFromSuperview()
    }
    
    func showEventTypePicker(data: [[String]]) {
        setValuesForPickerAndTextField(picker: &eventTypePicker, data: data, textField: eventTypeTextField)
    }
    
    func hideEventTypePicker() {
        eventTypePicker?.removeFromSuperview()
    }
}
