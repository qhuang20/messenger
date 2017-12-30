//
//  FriendControllerHelper.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-23.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit
import CoreData

class SubFriendsController: FriendsController {
    
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

        let mark = createFriendWith(name: "Mark", profileImageName: "zuckprofile")
        createMessageWith(text: "How are you doing today Jeffery?", friend: mark, minutesAgo: 0)

        let steve = createFriendWith(name: "Steve", profileImageName: "steve_profile")
        createMessageWith(text: "Good morning..", friend: steve, minutesAgo: 3)
        createMessageWith(text: "Hello, how are you?", friend: steve, minutesAgo: 2, isSender: true)
        createMessageWith(text: "Are you interested in buying an Apple device? We have a wide variety of apple devices that will suit your needs. Please make your purchase with us", friend: steve, minutesAgo: 1)
        createMessageWith(text: "Hello, how are you? blalaalallalalalallalalalalalalalAre you interested in buying an Apple device? We have a wide variety of apple devices that will suiaallalalalalalala", friend: steve, minutesAgo: 0.7, isSender: true)
        createMessageWith(text: "Are you interested in buying an Apple device? We have a wide variety of apple devices that will suit your needs. Please make your purchase with us", friend: steve, minutesAgo: 0.5)
        createMessageWith(text: "Hello, how are you? blalaalallalalalallalalalalalalalaallalalalalalala. Are you interested in buying an Apple device? We have a wide variety of apple devices that will suit your needs. Please make your purchase with us", friend: steve, minutesAgo: 0.2, isSender: true)
         createMessageWith(text: "Hello, how are you? blalaalallalalalallalalalalalalalaallalalalalalala. Are you interested in buying an Apple device? We have a wide variety of apple devices that will suit your needs. Please make your purchase with us", friend: steve, minutesAgo: 0.1, isSender: true)
        
        let donald = createFriendWith(name: "Donald Trump", profileImageName: "donald_trump_profile")
        createMessageWith(text: "You're fired", friend: donald, minutesAgo: 5)
        createMessageWith(text: "You're beutiful", friend: donald, minutesAgo: 1)
        createMessageWith(text: "China", friend: donald, minutesAgo: 4)
        
        let gandhi = createFriendWith(name: "Mahatma Gandhi", profileImageName: "gandhi")
        createMessageWith(text: "Love, Peace, and Joy", friend: gandhi, minutesAgo: 60 * 24)
        
        let hillary = createFriendWith(name: "Hillary Clinton", profileImageName: "hillary_profile")
        createMessageWith(text: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
    
    private func createFriendWith(name: String, profileImageName: String) -> Friend {
        let friend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        friend.name = name
        friend.profileImageName = profileImageName
        
        return friend
    }
    
    private func createMessageWith(text: String, friend: Friend, minutesAgo: Double, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        
        friend.lastMessage = message////
    }
    
    static func createMessageWith(text: String, friend: Friend, minutesAgo: Double, isSender: Bool = false) {
        let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!

        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
    }
    
}

