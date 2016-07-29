//
//  AppDelegate.swift
//  Polly
//
//  Created by Nikki Fernandez on 28/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor.whiteColor()
        
        let pollyVC : PollyViewController = PollyViewController()
        let savedVC : SavedViewController = SavedViewController()
        let pollyNavController : UINavigationController = UINavigationController(rootViewController: pollyVC)
        let savedNavController : UINavigationController = UINavigationController(rootViewController: savedVC)
        
        let pollyTabBarItem : UITabBarItem = UITabBarItem(title: "Polly", image: nil, tag: 0)
        pollyTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15)
        let savedTabBarItem : UITabBarItem = UITabBarItem(title: "Saved", image: nil, tag: 0)
        savedTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15)
        
        pollyNavController.navigationBar.translucent = true
        pollyNavController.navigationBar.backgroundColor = COLOR_POLLY_GREEN
        pollyNavController.tabBarItem = pollyTabBarItem
        savedNavController.tabBarItem = savedTabBarItem
        
        let controllers = [pollyNavController, savedNavController]
        tabBarController.viewControllers = controllers

        UITabBar.appearance().barTintColor = COLOR_POLLY_THEME_DARK
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name:"Helvetica-Bold", size:13)!], forState: .Normal)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = COLOR_POLLY_GREEN

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = tabBarController
        self.window!.makeKeyAndVisible()
        
        
        for name in UIFont.familyNames() {
            if let nameString = name as? String
            {
                print(UIFont.fontNamesForFamilyName(nameString))
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

