//
//  CustomTabBarController.swift
//  facebookfeed
//
//  Created by HieuTong on 1/16/21.
//  Copyright © 2021 HieuTong. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "New Feed"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "news_feed_icon")
        
        let friendRequestController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = #imageLiteral(resourceName: "requests_icon")
        
        let messengerVC = UIViewController()
        messengerVC.navigationItem.title = "Title"
        let messengerNavigationController = UINavigationController(rootViewController: messengerVC)
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.tabBarItem.image = #imageLiteral(resourceName: "messenger_icon")
        
        let notiNavigationController = UINavigationController(rootViewController: UIViewController())
        notiNavigationController.title = "Notification"
        notiNavigationController.tabBarItem.image = #imageLiteral(resourceName: "globe_icon")
        
        let settingNavigationController = UINavigationController(rootViewController: UIViewController())
        settingNavigationController.title = "Setting"
        settingNavigationController.tabBarItem.image = #imageLiteral(resourceName: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notiNavigationController, settingNavigationController]
        
        tabBar.isTranslucent = false
    
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(r: 229, g: 231, b: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }
}
