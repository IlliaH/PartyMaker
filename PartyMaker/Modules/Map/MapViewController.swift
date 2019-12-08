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
    var loader : FillableLoader?
    let eventService : EventServiceProtocol = EventService()
    var selectedEventId : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getEvents()
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
    
    func createAnnotationImageView(image : UIImage) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = image
        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    func getEvents() {
        eventService.getEvents { (events, error) in
            if let error = error {
                // show alert
            } else {
                if let events = events {
                    for event in events {
                        guard let latitude = event.latitude, let longitude = event.longitude else {return}
                        let lat = Double(truncating: latitude as NSNumber)
                        let lon = Double(truncating: longitude as NSNumber)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        var image : UIImage?
                        if let imageData = event.picture {
                            image = UIImage(data: imageData)
                        } else {
                            image = UIImage(named: "PartyMaker")
                        }
                        guard let id = event.id, let title = event.name else {return}
                        let customAnnotation = CustomAnnotation(id: id, title: title, image: image!, coordinate: coordinate)
                        self.mapView.addAnnotation(customAnnotation)
                    }
                }
            }
        }
    }

}


extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        let identifier = "Location"

        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        let customAnnotation = annotation as! CustomAnnotation
        guard let image = customAnnotation.image else {return nil}
        let imageView = createAnnotationImageView(image: image)
        anView?.addSubview(imageView)
        anView?.frame = imageView.frame
        let callOutButton = UIButton(type: .detailDisclosure)
        anView?.rightCalloutAccessoryView = callOutButton
        anView?.calloutOffset = CGPoint(x: 0, y: -10)

        return anView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetails"{
            let detailNC = segue.destination as! UINavigationController
            let detailVC = detailNC.topViewController as! EventDetailsViewController
            detailVC.eventId = selectedEventId
            
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("Button tapped")
            let selectedAnnotation = view.annotation as! CustomAnnotation
            selectedEventId = selectedAnnotation.id
            performSegue(withIdentifier: "goToEventDetails", sender: nil)
        }
    }
}
