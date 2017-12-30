//
//  ChatLogMessageCell.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-29.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            
            guard let message = message else { return }
            
            if let profileImageName = message.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            guard let messageText = message.text else { return }
            
            messageTextView.text = messageText
            let estimatedFrame = ChatLogController.getEstimatedTextFrame(messageText: messageText)
            let estimatedHeight = estimatedFrame.height + 20
            let estimatedWidth = estimatedFrame.width + 16
            
            if message.isSender {
                let windowView = UIApplication.shared.keyWindow!
                let myX = windowView.frame.width - estimatedFrame.width - 16 - 16
                
                messageTextView.frame = CGRect(x: myX, y: 0, width: estimatedWidth, height: estimatedHeight)
                textBubbleView.frame = CGRect(x: myX - 8, y: 0, width: estimatedWidth + 8, height: estimatedHeight)
                
                profileImageView.isHidden = true
                textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                messageTextView.textColor = UIColor.white
                
            } else {
                messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedWidth, height: estimatedHeight)
                textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedWidth + 8, height: estimatedHeight)
                
                profileImageView.isHidden = false
                textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                messageTextView.textColor = UIColor.black
            }
            
        }
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWith(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWith(format: "V:[v0(30)]|", views: profileImageView)
    }
    
}
//Chat Bubbles With Tails!
//https://www.youtube.com/watch?v=kR9cf_K_9Tk&list=PL0dzCUj1L5JHGoEg41IJNk9QQ_hPWcyRo&index=6
