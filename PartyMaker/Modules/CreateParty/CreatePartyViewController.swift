//
//  CreatePartyViewController.swift
//  PartyMaker
//
//  Created by 8teRnity on 11/16/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import DateTimePicker

class CreatePartyViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    
    var startdateTimePicker: DateTimePicker?
    var enddateTimePicker: DateTimePicker?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func selectStartDateOnTouch(_ sender: UIButton) {
        // Tag 0 = start date
        if sender.tag == 0 {
            guard let startdateTimePicker = startdateTimePicker else {
                self.startdateTimePicker = createAndReturnDate(min: Date(), max: Date().addingTimeInterval(60 * 60 * 24 * 4 * 12 * 6), textField: startDateTextField)
                return
            }
            
            self.view.addSubview(startdateTimePicker)
            
        }
        // Tag 1 = end date
        else if sender.tag == 1 {
            if startdateTimePicker?.selectedDate == nil {
                // Alert
                print("select start date")
            }
            else {
                guard let enddateTimePicker = enddateTimePicker else {
                    let minDate = startdateTimePicker?.selectedDate.addingTimeInterval(60 * 60 * 2) ?? Date()
                    self.enddateTimePicker = createAndReturnDate(min: minDate, max: Date().addingTimeInterval(60 * 60 * 24 * 4 * 12 * 6), selectedDate: minDate, textField: endDateTextField)
                    return
                }
                
                self.view.addSubview(enddateTimePicker)
            }
        }
        
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
        
        
        picker.dismissHandler = {
            picker.removeFromSuperview()
        }
        
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
}
