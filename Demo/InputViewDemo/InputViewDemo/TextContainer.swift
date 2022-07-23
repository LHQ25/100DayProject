//
//  TextContainer.swift
//  InputViewDemo
//
//  Created by 9527 on 2022/7/23.
//

import Foundation
import UIKit

/* textContainer */
extension ViewController {
    
    func textContainerManager() {
        
//        let textContainer = textView.textContainer
        
        let textContainer = CreatingTextContainer()
    }
    
    fileprivate func CreatingTextContainer () -> NSTextContainer {
        
        let textContainer = NSTextContainer(size: CGSize(width: UIScreen.main.bounds.width, height: 200))
        
        
        return textContainer
        
    }
}
