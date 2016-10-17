//
//  ConversationCellTableViewCell.swift
//  Chat
//
//  Created by zerg on 22.06.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class ConversationCellTableViewCell: UITableViewCell {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var message: UILabel!
    @IBOutlet var datum: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var leftMarginDate: NSLayoutConstraint!
    @IBOutlet var rightMarginMessage: NSLayoutConstraint!
    @IBOutlet var leftMarginMessage: NSLayoutConstraint!
    @IBOutlet var rightMarginName: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
        
        if (aD.IOS8 == nil) {
            rightMarginMessage.constant = 22
            leftMarginMessage.constant = 22
            leftMarginDate.constant = 22
            rightMarginName.constant = -22
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        message.numberOfLines = 0
        // Configure the view for the selected state
    }
    
}
