//
//  ContactTableViewCell.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(contactName : String) {
        self.contactNameLabel.text = contactName
    }
    
    func toggleChecked() {
        if checkmarkLabel.text == ""{
            checkmarkLabel.text = "√"
        }else {
            checkmarkLabel.text = ""
            print(checkmarkLabel.text)
        }
    }

}
