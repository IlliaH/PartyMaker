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
    
    @IBOutlet weak var logoImageView: RoundImageView!
    
    @IBOutlet weak var nameTextField: CustomHoshiTextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var hashtagsTextField: CustomHoshiTextField!
    
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    
    @IBOutlet weak var addressTextField: CustomHoshiTextField!
    
    @IBOutlet weak var isPrivateSwitch: UISwitch!
    
    @IBOutlet weak var ageCategoryTextField: CustomHoshiTextField!
    
    @IBOutlet weak var eventTypeTextField: CustomHoshiTextField!
    
    @IBOutlet weak var numberOfPeopleTextField: CustomHoshiTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var startdateTimePicker: DateTimePicker?
    var enddateTimePicker: DateTimePicker?
    
    var ageCategoryPicker: McPicker?
    var eventTypePicker: McPicker?
    
    var presenter: CreatePartyPresenterProtocol!
    var configurator: CreatePartyConfiguratorProtocol = CreatePartyConfigurator()
    var loader : FillableLoader?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func selectStartDateOnTouch(_ sender: UIButton) {
        // Tag 0 = start date
        if sender.tag == 0 {
            presenter.showStartCalendarClicked()
        }
        // Tag 1 = end date
        else if sender.tag == 1 {
            presenter.showEndCalendarClicked()
        }
    }
    
    @IBAction func pickerOnTouch(_ sender: UIButton) {
        if sender.tag == 0 {
            presenter.showAgeCategoryPickerClicked()
        }
        else if sender.tag == 1 {
            presenter.showEventTypePickerClicked()
        }
    }
    
    @IBAction func pictureOnTouch(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) { }
    }
    
    @IBAction func createButtonOnTouch(_ sender: UIButton) {
        presenter.pictureValueChanged(to: logoImageView.image)
        presenter.nameValueChanged(to: nameTextField.text)
        presenter.descriptionValueChanged(to: descriptionTextView.text)
        presenter.hashtagsValueChanged(to: hashtagsTextField.text)
        presenter.startDateValueChanged(to: startdateTimePicker?.selectedDate)
        presenter.endDateValueChanged(to: enddateTimePicker?.selectedDate)
        presenter.isPrivateValueChanged(to: isPrivateSwitch.isOn)
        presenter.numberOfPeopleChanged(to: numberOfPeopleTextField.text)
        presenter.ageCategoryValueChanged(to: ageCategoryTextField.text)
        presenter.eventTypeValueChanged(to: eventTypeTextField.text)
        
        presenter.createButonClicked()
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
    
    @IBAction func onScreenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func presentView() {
        DispatchQueue.main.async {
            if let tabBbar = self.tabBarController{
                tabBbar.selectedIndex = 0
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + CGFloat(AppConstant.tabBarInset)
        self.scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = Alert.createAlert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
        }
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
        DispatchQueue.main.async {
            self.setValuesForPickerAndTextField(picker: &self.ageCategoryPicker, data: data, textField: self.ageCategoryTextField)
        }
    }
    
    func hideAgeCategoryPicker() {
        ageCategoryPicker?.removeFromSuperview()
    }
    
    func showEventTypePicker(data: [[String]]) {
        DispatchQueue.main.async {
            self.setValuesForPickerAndTextField(picker: &self.eventTypePicker, data: data, textField: self.eventTypeTextField)
        }
    }
    
    func hideEventTypePicker() {
        eventTypePicker?.removeFromSuperview()
    }
}


extension CreatePartyViewController : PassLocationDelegate {
    func passEventLocation(latitude: Decimal, longitude: Decimal, address: String) {
        presenter.latitudeValueChanged(to: latitude)
        presenter.longitudeValueChanged(to: longitude)
        addressTextField.text = address
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAddressSegue" {
            let selectAddressVC = segue.destination as! SelectAddressViewController
            selectAddressVC.delegate = self
        }
    }
}

extension CreatePartyViewController : UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
       }
       else if let nextTextView = textField.superview?.viewWithTag(textField.tag + 1) as? UITextView {
            nextTextView.becomeFirstResponder()
       }
       else {
            textField.resignFirstResponder()
            return true;
       }
       return false
    }
}
