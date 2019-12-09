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
        if let secretCode = secretCodeTextField.text {
            if secretCode.isNotEmpty {
                eventService.joinPrivateEvent(code: secretCode) { (event, error) in
                    if let error = error {
                        // Alert error
                        print(error as Any)
                    }
                    else if let event = event {
                        self.eventId = event.id
                        self.performSegue(withIdentifier: "fromJoinToEventDetails", sender: nil)
                    }
                }
            }
        }
    }
    
}
