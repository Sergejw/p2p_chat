//
//  Contact.swift
//  Chat
//
//  Created by zerg on 24.06.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var about_me: String
    @NSManaged var age: NSDate
    @NSManaged var gender: String
    @NSManaged var id: String
    @NSManaged var interests: String
    @NSManaged var is_friend: NSNumber
    @NSManaged var mood: String
    @NSManaged var name: String

}
