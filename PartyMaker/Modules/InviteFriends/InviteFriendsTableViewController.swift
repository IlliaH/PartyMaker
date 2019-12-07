//
//  TableViewController.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import MessageUI

class InviteFriendsTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    var phoneService : PhoneService = PhoneService()
    var phoneContact = [PhoneContact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneContact += phoneService.getPhoneContacts()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneContact.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as! ContactTableViewCell
        let contactName = phoneContact[indexPath.row].contactName
        if let contactTitle = contactName {
            cell.configure(contactName: contactTitle)
        } else {
            cell.configure(contactName: " ")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
         if phoneContact[indexPath.row].isChecked == true {
            phoneContact[indexPath.row].isChecked = false
            print(phoneContact[indexPath.row].isChecked)
        }else {
            phoneContact[indexPath.row].isChecked = true
            print(phoneContact[indexPath.row].isChecked)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        cell.toggleChecked()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func sendInvitationButtonOnTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Send invitation", message: "Enter secret code:", preferredStyle: .alert)
        alert.addTextField { (textField) in
        }
        
        let action = UIAlertAction(title: "Ok", style: .default) { [unowned alert] _ in
            let text = alert.textFields?.first?.text
            if let secretCode = text {
                self.sendSMS(secretCode: secretCode)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    func sendSMS(secretCode : String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            if secretCode.isNotEmpty{
                messageVC.body = secretCode
                let recipients = phoneContact.filter({$0.isChecked == true})
                if recipients.count > 0 {
                    var numbers = [String]()
                    for recipient in recipients {
                        if let receiver = recipient.contactNumber {
                            numbers.append(receiver)
                        }
                    }
                    messageVC.recipients = numbers
                    self.present(messageVC, animated: true, completion: nil)
                }else {
                    // alert no recipients selected
                }
            
            } else {
                // alert secret code is empty
                
            }
            
        }else {
            // alert unable to send message
        }
    }
    
    
}
