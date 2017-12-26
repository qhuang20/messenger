//
//  CustomTabBarController.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-25.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        let layout = UICollectionViewFlowLayout()
        let subFriendsController = SubFriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: subFriendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [
            recentMessagesNavController,
            createDummyNavControllerWith(title: "Calls", imageName: "calls"),
            createDummyNavControllerWith(title: "Groups", imageName: "groups"),
            createDummyNavControllerWith(title: "People", imageName: "people"),
            createDummyNavControllerWith(title: "Settings", imageName: "settings")
        ]
    }
    
    private func createDummyNavControllerWith(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
