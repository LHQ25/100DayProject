//
//  SettingsTableViewController.swift
//  Pet Finder
//
//  Created by Essan Parto on 5/16/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  @IBOutlet weak var themeSelector: UISegmentedControl!
  @IBOutlet weak var applyButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .done, target: self, action: #selector(dismissd))
    
    /// 修改到当前配置的主题
    themeSelector.selectedSegmentIndex = ThemeManager.currentTheme().rawValue
  }
    
  @objc func dismissd() {
    
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func applyTheme(sender: UIButton) {
    ///退出时修改 主题
    if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
        ThemeManager.applyTheme(theme: selectedTheme)
    }
    dismissd()
  }
}
