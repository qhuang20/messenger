//
//  FriendControllerHelper.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-23.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit


extension FriendsController {
    
    func setupData() {
        let mark = Friend()
        mark.name = "Mark"
        mark.profileImageName = "zuckprofile"
        
        let message = Message()
        message.text = "hahhahahaha"
        message.date = Date() as NSDate
        message.friend = mark
        
        let steve = Friend()
        steve.name = "Steve"
        steve.profileImageName = "steve_profile"
        
        let steveMessage = Message()
        steveMessage.text = "hahhahahaha"
        steveMessage.date = Date() as NSDate
        steveMessage.friend = steve
        
        messages = [message, steveMessage]
    }
    
}
