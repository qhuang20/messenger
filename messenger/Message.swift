//
//  Message+CoreDataClass.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-23.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//
//

import UIKit
import CoreData


public class Message: NSManagedObject {
    
    static func createMessageWith(text: String, friend: Friend, minutesAgo: Double, isSender: Bool = false) {
        let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
        
        let message = Message(context: context)
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
    }
    
}
