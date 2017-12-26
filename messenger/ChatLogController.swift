//
//  ChatLogController.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-24.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    
    var messages: [Message]?
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
    
        guard let message = messages?[indexPath.item] else { return cell }
        
        if let profileImageName = message.friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
        }
        
        if let messageText = message.text {
            cell.messageTextView.text = messageText
            let estimatedFrame = getEstimatedTextFrame(messageText: messageText)
            let estimatedHeight = estimatedFrame.height + 20
            let estimatedWidth = estimatedFrame.width + 16
            
            if message.isSender {
                let  myX = view.frame.width - estimatedFrame.width - 16 - 16
                
                cell.messageTextView.frame = CGRect(x: myX, y: 0, width: estimatedWidth, height: estimatedHeight)
                cell.textBubbleView.frame = CGRect(x: myX - 8, y: 0, width: estimatedWidth + 8, height: estimatedHeight)
                
                cell.profileImageView.isHidden = true
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.white
            
            } else {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedWidth, height: estimatedHeight)
                cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedWidth + 8, height: estimatedHeight)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
        
            let estimatedFrame = getEstimatedTextFrame(messageText: messageText)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    private func getEstimatedTextFrame(messageText: String) -> CGRect {
        let size = CGSize(width: 275, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    
        return estimatedFrame
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
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
