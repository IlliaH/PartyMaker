//
//  PhoneService.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneService {
    var contactStore = CNContactStore()
    
    private var contacts = [CNContact]()
    let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
    CNContactPhoneNumbersKey] as [Any]
    var allContainers : [CNContainer] = []
    
    private var phoneContacts = [PhoneContact]()
    
    init() {
        getPhoneNumbers()
    }
    
     private func getPhoneNumbers() {
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        for container in allContainers {
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
        do {
            let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keys as! [CNKeyDescriptor])
            contacts.append(contentsOf: containerResults)
        }catch {
            print("error fetching containers")
        }
        }
        
    }
    
    func getPhoneContacts() -> [PhoneContact] {
        var name = ""
        var number = ""
        contacts.forEach { (contact) in
            name = contact.givenName
            contact.phoneNumbers.forEach { (phoneNumer) in
                if let fullMobNumer = phoneNumer.value as? CNPhoneNumber {
                    number = fullMobNumer.value(forKey: "digits") as? String ?? ""
                }
            }
            var phoneContact = PhoneContact(contactName: name, contactNumber: number)
            self.phoneContacts.append(phoneContact)
        }
        return phoneContacts
    }
    
}
