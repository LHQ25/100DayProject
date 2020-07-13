/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell


import UIKit

let swiftOrangeColor = UIColor(red: 248 / 255.0, green: 96 / 255.0, blue: 47 / 255.0, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UILabel.appearance().font = UIFont(name: "Avenir-Light", size: 17.0)
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).font =
            UIFont(name: "Avenir-light", size: 14.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = swiftOrangeColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            // swiftlint:disable:next force_unwrapping
            NSAttributedString.Key.font: UIFont(name: "Avenir-light", size: 17.0)!
        ]
        UITableView.appearance().separatorColor = swiftOrangeColor
        UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
        UISwitch.appearance().tintColor = swiftOrangeColor
        UISlider.appearance().tintColor = swiftOrangeColor
        UISegmentedControl.appearance().tintColor = swiftOrangeColor
        
        return true
    }
}
