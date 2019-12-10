//
//  UserEventTableViewCell.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-12-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit

class UserEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventPictureImageView: RoundImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(eventName : String, imageData : Data){
        self.eventNameLabel.text = eventName
        self.eventPictureImageView.image = UIImage(data: imageData)
    }

}
