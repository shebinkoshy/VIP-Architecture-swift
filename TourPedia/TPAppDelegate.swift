//
//  AppDelegate.swift
//  TourPedia
//
//  Created by Shebin Koshy on 25/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import UIKit

@UIApplicationMain
class TPAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = TPReviewParameterViewController.instance(storyboardName: "TPMain", bundle:nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    
}

