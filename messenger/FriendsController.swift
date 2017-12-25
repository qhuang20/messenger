//
//  ViewController.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-20.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit


class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var messages: [Message]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
    }
    
    internal func setupData() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
}




