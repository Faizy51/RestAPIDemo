//
//  CustomTableViewCell.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var roomName: UILabel!
    
    var roomData: RoomData? {
        willSet {
            self.orgName.text = newValue?.org.name
            self.propertyName.text = newValue?.property.name
            self.roomName.text = newValue?.room.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
