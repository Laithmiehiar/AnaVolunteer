//
//  CustomTabBarController.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/25/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
class CustomTabBarController : UITabBarController{
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let controller1 = HomePageVC()
//        //        controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
//        controller1.tabBarItem = UITabBarItem(title: "Home",image: UIImage(named: "office-calendar"), tag: 1)
//        let nav1 = UINavigationController(rootViewController: controller1)
//        
//        let controller2 = UIViewController()
//        controller2.tabBarItem = UITabBarItem(title: "list",image: UIImage(named: "list"), tag: 2)
//        let nav2 = UINavigationController(rootViewController: controller2)
//       
//        let controller3 = UIViewController()
//        let nav3 = UINavigationController(rootViewController: controller3)
//        nav3.title = ""
//        
//        let controller4 = UIViewController()
//        controller4.tabBarItem = UITabBarItem(title: "Notifications",image: UIImage(named: "notification-bell"), tag: 4)
//        let nav4 = UINavigationController(rootViewController: controller4)
//        
//        let controller5 = UIViewController()
//        controller5.tabBarItem = UITabBarItem(title: "Profile",image: UIImage(named: "puser"), tag: 5)
//        let nav5 = UINavigationController(rootViewController: controller5)
//        
//        
//        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        setupMiddleButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    // MARK: - Setups
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        //menuButton.backgroundColor = UIColor(red:0.33, green:0.76, blue:0.79, alpha:1.0)
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "plus"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    
    // MARK: - Actions
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
    }
    
}
