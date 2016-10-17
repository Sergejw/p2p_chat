//
//  Message.swift
//  Chat
//
//  Created by zerg on 24.06.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var from: String
    @NSManaged var id: String
    @NSManaged var text: String
    @NSManaged var height: NSNumber

}
