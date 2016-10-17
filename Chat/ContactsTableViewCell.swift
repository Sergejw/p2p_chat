//
//  ContactsTableViewCell.swift
//  Chat
//
//  Created by zerg on 08.07.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var buddy: UILabel!
    @IBOutlet var online: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
