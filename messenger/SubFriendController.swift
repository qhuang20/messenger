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
    
    private func clearData() {
        
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
    
    override func setupData() {
        
        clearData()
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark"
        mark.profileImageName = "zuckprofile"

        let markMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        markMessage.text = "hahhahahaha"
        markMessage.date = Date() as NSDate
        markMessage.friend = mark

        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve"
        steve.profileImageName = "steve_profile"
        
        createMessageWith(text: "Good morning..", friend: steve, minutesAgo: 3, context: context)
        createMessageWith(text: "Hello, how are you?", friend: steve, minutesAgo: 2, context: context)
        createMessageWith(text: "Are you interested in buying an Apple device?", friend: steve, minutesAgo: 1, context: context)
        
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "donald_trump_profile"
        
        createMessageWith(text: "You're fired", friend: donald, minutesAgo: 5, context: context)
        createMessageWith(text: "You're beutiful", friend: donald, minutesAgo: 1, context: context)
        createMessageWith(text: "China", friend: donald, minutesAgo: 4, context: context)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
        loadData()
    }
    
    private func createMessageWith(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    private func loadData() {
        
        let frineds = fetchFriends()
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()

        for friend in frineds {
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
            fetchRequest.fetchLimit = 1
           
            do {
                
                let fetchedMessages = try context.fetch(fetchRequest)
                messages?.append(contentsOf: fetchedMessages)

            } catch let err { print(err) }
        }
        
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})//TODO - check it out
        
    }
    
    private func fetchFriends() -> [Friend] {
        
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()

        do {
            
            return try context.fetch(fetchRequest)
            
        } catch let err { print(err) }
        
        return []
    }
    
}

