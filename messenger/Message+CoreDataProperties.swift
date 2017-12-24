//
//  Message+CoreDataProperties.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-23.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}
