//
//  MapViewController.swift
//  PartyMaker
//
//  Created by 8teRnity on 12/1/19.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MapBaseViewController {
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var currentLocationImageView: UIImageView!
    
    var isSettingsHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onScreenTapped(_ sender: UITapGestureRecognizer) {
        showSettingsView(isSettingsHidden)
    }
    
    func showSettingsView(_ isHidden: Bool) {
        isSettingsHidden = !isHidden
        
        listImageView.isHidden = isSettingsHidden
        settingsImageView.isHidden = isSettingsHidden
        currentLocationImageView.isHidden = isSettingsHidden
    }
    
    @IBAction func currentLocationOnTapped(_ sender: UITapGestureRecognizer) {
        centerViewOnUserLocation()
    }
}
