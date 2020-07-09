//
//  AppDelegate.swift
//  Day3_UISearchController
//
//  Created by 娄汉清 on 2020/7/9.
//  Copyright © 2020 娄汉清. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppearance()
        
        return true
    }
    
    func configureAppearance() {
        UISearchBar.appearance().tintColor = .candyGreen
        UINavigationBar.appearance().tintColor = .candyGreen
    }
    
    
}

