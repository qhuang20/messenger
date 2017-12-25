//
//  FriendControllerHelper.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-23.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit
import CoreData

class SubFriendController: FriendsController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    
    override func setupData() {
        
        clearData()
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark"
        mark.profileImageName = "zuckprofile"
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = "hahhahahaha"
        message.date = Date() as NSDate
        message.friend = mark
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve"
        steve.profileImageName = "steve_profile"
        
        let steveMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        steveMessage.text = "hahhahahaha"
        steveMessage.date = Date() as NSDate
        steveMessage.friend = steve
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
        loadData()
    }
    
    func clearData() {
        
        do {
            
            let entities = [Message.self, Friend.self]
            
            for entity in entities {
                let fetchRequest: NSFetchRequest<NSManagedObject> = entity.fetchRequest() as! NSFetchRequest<NSManagedObject>

                let objects = try context.fetch(fetchRequest)
                
                for object in objects {
                    context.delete(object)
                }
            }
            
            try(context.save())
            
        } catch let err { print(err) }
        
    }
    
    private func loadData() {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        
        do {
            
            messages = try context.fetch(fetchRequest)
            
        } catch let err { print(err) }
        
    }
    
}

