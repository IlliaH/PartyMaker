//
//  JoinPrivateEventViewController.swift
//  PartyMaker
//
//  Created by 8teRnity on 12/8/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class JoinPrivateEventViewController: UIViewController {

    @IBOutlet weak var secretCodeTextField: CustomHoshiTextField!
    
    let eventService = EventService()
    var eventId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromJoinToEventDetails" {
            let navigationVC = segue.destination as! UINavigationController
            let detailsVC = navigationVC.topViewController as! EventDetailsViewController
            detailsVC.eventId = eventId
        }
    }
    
    @IBAction func joinButtonOnTouch(_ sender: UIButton) {
        view.endEditing(true)
        if let secretCode = secretCodeTextField.text {
            if secretCode.isNotEmpty {
                eventService.joinPrivateEvent(code: secretCode) { (event, error) in
                    if let error = error {
                        let alert = Alert.createAlert(title: "Attention", message: "Secret code is incorrect")
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if let event = event {
                        self.eventId = event.id
                        self.performSegue(withIdentifier: "fromJoinToEventDetails", sender: nil)
                    }
                }
            } else {
                let alert = Alert.createAlert(title: "Attention", message: "Please, type secret code")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onScreenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension JoinPrivateEventViewController : UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
