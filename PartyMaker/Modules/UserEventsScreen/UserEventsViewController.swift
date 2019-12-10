//
//  UserEventsViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class UserEventsViewController: UIViewController {
    
    var createdShortEvents = [EventShort]()
    var followedShortEvents = [EventShort]()
    
    var selectedEventId : Int?
    var loader : FillableLoader?
    
    @IBOutlet weak var eventSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let eventService = EventService()

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCretedEvents()
        getUserFollowedEvents()
        eventSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged(segment:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getUserCretedEvents() {
            showLoader()
            eventService.getUserEvents { (createdEventsShort, error) in
                if let error = error {
                    print("No data retrieved")
                } else if createdEventsShort != nil {
                    self.createdShortEvents = createdEventsShort!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                self.hideLoader()
            }
    }
    
    func getUserFollowedEvents() {
        eventService.getFollowedEvents { (eventsShort, error) in
            if let error = error {
                print("No data retrieved")
            } else if eventsShort != nil  {
                self.followedShortEvents = eventsShort!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
  @objc func segmentControlValueChanged(segment: UISegmentedControl) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetails"{
            let detailNC = segue.destination as! UINavigationController
            let detailVC = detailNC.topViewController as! EventDetailsViewController
            detailVC.eventId = selectedEventId
        }
    }
    
}

extension UserEventsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    var number : Int = 0
        // UserEvents segment
        if eventSegmentControl.selectedSegmentIndex == 0 {
            number = returnNumberOfRowsForTableView(eventsShort: createdShortEvents)
            // FollowedEvents segment
        } else if eventSegmentControl.selectedSegmentIndex == 1 {
            number = returnNumberOfRowsForTableView(eventsShort: followedShortEvents)
        }
        return number
    }
    
    func returnNumberOfRowsForTableView(eventsShort : [EventShort])-> Int {
        if eventsShort.first != EventShort() {
            return eventsShort.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! UserEventTableViewCell
        // UserEvents segment
        if eventSegmentControl.selectedSegmentIndex == 0 {
        cell = returnCellForTableView(cell: cell, eventsShot: createdShortEvents, indexPath: indexPath)
        // FollowedEvents segment
        } else if eventSegmentControl.selectedSegmentIndex == 1 {
        cell = returnCellForTableView(cell: cell, eventsShot: followedShortEvents, indexPath: indexPath)
        }
        
        return cell
    }
    
    func returnCellForTableView(cell : UserEventTableViewCell, eventsShot : [EventShort], indexPath : IndexPath) -> UserEventTableViewCell{
        let event = eventsShot[indexPath.row]
        let name = event.name ?? "name was not retrieved"
        if let imageData = event.picture {
            cell.configureCell(eventName: name, imageData: imageData)
        }else {
            let imageData = UIImage(named: "PartyMaker")?.pngData()
            cell.configureCell(eventName: name, imageData: imageData!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // UserEvents segment
        if eventSegmentControl.selectedSegmentIndex == 0 {
            let event = createdShortEvents[indexPath.row]
            selectedEventId = event.id
        // FollowedEvents segment
        } else if eventSegmentControl.selectedSegmentIndex == 1 {
            let event = followedShortEvents[indexPath.row]
            selectedEventId = event.id
        }
        performSegue(withIdentifier: "goToEventDetails", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if eventSegmentControl.selectedSegmentIndex == 1 {
            let unfollowAction = UIContextualAction(style: .destructive, title: "Unfollow") { (action, view, success) in
                let id = self.followedShortEvents[indexPath.row].id!
                self.eventService.unfollowEvent(id: id) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        self.getUserFollowedEvents()
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [unfollowAction])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
    }
    
}

extension UserEventsViewController {
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
