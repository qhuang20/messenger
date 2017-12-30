//
//  ChatLogController.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-24.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
        
    let cellId = "cellId"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend() {

        SubFriendsController.createMessageWith(text: inputTextField.text!, friend: friend!, minutesAgo: 0, isSender: true)
        
        do {
            try context.save()

            inputTextField.text = nil
            
        } catch let err {
            print(err)
        }
    }
    
    lazy var fetchedResultsControler: NSFetchedResultsController<Message> = {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
 
    @objc func simulate() {
        SubFriendsController.createMessageWith(text: "Here's a text message that was sent a few minutes ago...", friend: friend!, minutesAgo: 0)
        SubFriendsController.createMessageWith(text: "Here's a text message that was sent a few minutes ago...", friend: friend!, minutesAgo: 0)
        
        do {
            try context.save()
            
        } catch let err {
            print(err)
        }
    }
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in blockOperations {
                operation.start()
            }
        }, completion: { (completed) in
            
            let item = self.fetchedResultsControler.sections![0].numberOfObjects - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
        })
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsControler.performFetch()
            
        } catch let err {
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWith(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWith(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let offset = CGPoint(x: 0, y: contentHeight - collectionViewHeight + 60)
        collectionView?.setContentOffset(offset, animated: true)//scoll to very bottom
    }
    
    lazy var contentHeight = collectionViewLayout.collectionViewContentSize.height
    lazy var collectionViewHeight = collectionView!.frame.height//if self unavailable
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        let keyBoardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        
        bottomConstraint?.constant = isKeyboardShowing ? -keyBoardFrame.height : 0

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()

        }, completion: { (completed) in
            if isKeyboardShowing {
                let item = self.fetchedResultsControler.sections![0].numberOfObjects - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWith(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        
        messageInputContainerView.addConstraintsWith(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWith(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWith(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWith(format: "V:|[v0(0.5)]", views: topBorderView)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsControler.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell//ReusableCell!!!!!!!!!!!
    
        cell.message = fetchedResultsControler.object(at: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsControler.object(at: indexPath)
       
        if let messageText = message.text {
        
            let estimatedFrame = ChatLogController.getEstimatedTextFrame(messageText: messageText)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
    }
    
    static func getEstimatedTextFrame(messageText: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)

        return estimatedFrame
    }
    
}


