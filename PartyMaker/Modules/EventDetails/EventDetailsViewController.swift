//
//  EventDetailsViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: CustomHoshiTextField!
    @IBOutlet weak var endDateTextField: CustomHoshiTextField!
    @IBOutlet weak var photoImageView: RoundImageView!
    @IBOutlet weak var partyNameTextField: CustomHoshiTextField!
    @IBOutlet weak var partyDescriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: CustomHoshiTextField!
    @IBOutlet weak var ageCategoryTextField: CustomHoshiTextField!
    @IBOutlet weak var eventTypeTextField: CustomHoshiTextField!
    @IBOutlet weak var peopleCounterSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendInvitationButtonOnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func saveChangesButtonOnTapped(_ sender: UIButton) {
        
    }
    
}
