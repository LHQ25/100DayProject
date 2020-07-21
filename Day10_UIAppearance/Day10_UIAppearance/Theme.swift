//
//  Theme.swift
//  Day10_UIAppearance
//
//  Created by 亿存 on 2020/7/21.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme: Int{
    case Default = 0, Dark, Graphical
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    //MARK: - 导航
    ///UINavigationBar and UIToolBar   style
    var barStyle: UIBarStyle {
        switch self {
        case .Default, .Graphical:
            return .default
        case .Dark:
            return .black
        }
    }
    ///navigationBackgroundImage
    var navigationBackgroundImage: UIImage? {
        return self == .Graphical ? UIImage(named: "navBackground") : nil
    }
    
    
    var tabBarBackgroundImage: UIImage? {
        return self == .Graphical ? UIImage(named: "tabBarBackground") : nil
    }
    
    //MARK: - TabBar
    var backgroundColor: UIColor {
        switch self {
        case .Default, .Graphical:
            return UIColor(white: 0.9, alpha: 1.0)
        case .Dark:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 140.0/255.0, green: 50.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
}



struct ThemeManager {

    ///当前主题
    static func currentTheme() -> Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: SelectedThemeKey)
        print("当前主题：",storedTheme)
        return Theme.init(rawValue: storedTheme)!
        //NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue
//        if let storedTheme = UserDefaults.standard.integer(forKey: SelectedThemeKey) {
//            return Theme(rawValue: NSInteger(storedTheme)!)!
//        } else {
//            return .Default
//        }
    }
    
    ///修改主题
    static func applyTheme(theme: Theme) {
        // 1
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // 2
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        /// UINav
        UINavigationBar.appearance().tintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        
        //返回键设置
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        ///返回时过渡遮罩层
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMask")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        ///Tabbar
        UITabBar.appearance().tintColor = theme.mainColor
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage

        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        ///Customizing a Segmented Control
        UISegmentedControl.appearance().tintColor = theme.mainColor
        
        let controlBackground = UIImage(named: "controlBackground")? .withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        ///Customizing Steppers, Sliders, and Switches
        UISlider.appearance().tintColor = theme.mainColor
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)

        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
//        UISwitch.appearance().tintColor = theme.mainColor
        
        ///Customizing a Single Instance
        
        //详见  PetTableViewController.swift   viewWillAppear     tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell   简单使用
        
    }
}
