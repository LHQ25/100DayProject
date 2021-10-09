//
//  TableHeaderView.swift
//  Day15_1  Swift(UITableView)
//
//  Created by 亿存 on 2020/7/29.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var label: UILabel!
    
    func setUI() {
        
        contentView.backgroundColor = randomColor()
        
        label = UILabel(frame: CGRect(x: 15, y: 0, width: 300, height: 50))
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        
        let constraint_left = NSLayoutConstraint(item: label!, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 15)
        let constraint_cy = NSLayoutConstraint(item: label!, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        contentView.addConstraints([constraint_left, constraint_cy])
        
    }

}

class TableFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var label: UILabel!
    
    func setUI() {
        
        contentView.backgroundColor = randomColor()
        
        label = UILabel(frame: CGRect(x: 15, y: 0, width: 300, height: 50))
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        
//        let constraint_left = NSLayoutConstraint(item: label!, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 15)
//        let constraint_cy = NSLayoutConstraint(item: label!, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
//        contentView.addConstraints([constraint_left, constraint_cy])
        
    }

}



/// 随机色
///
/// - Returns: 返回随机色
func randomColor() -> UIColor {
    
    let red = CGFloat(arc4random()%256)/255.0
    let green = CGFloat(arc4random()%256)/255.0
    let blue = CGFloat(arc4random()%256)/255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}
