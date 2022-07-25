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
        
        let textContainer = textView.textContainer
        
//        let textContainer = CreatingTextContainer()
        
        ManagingTextComponents(textContainer: textContainer)
        
        DefiningtheContainerShape(textContainer: textContainer)
        
        ConstrainingTextLayout(textContainer: textContainer)
    }
    
    //MARK: - CreatingTextContainer
    fileprivate func CreatingTextContainer () -> NSTextContainer {
        
        let textContainer = NSTextContainer(size: CGSize(width: UIScreen.main.bounds.width, height: 200))
        return textContainer
    }
    
    //MARK: - Managing Text Components
    func ManagingTextComponents(textContainer: NSTextContainer) {
        
        /*
         TextView的布局管理器
         避免直接通过此属性分配布局管理器。 相反，当您想要替换布局管理器时，请使用 replaceLayoutManager(_:) 方法。
         当您使用 addTextContainer(_:) 方法将文本容器添加到布局管理器时，框架会自动设置此属性的值。
         */
        let layoutManager = textContainer.layoutManager
        let textLayoutManager = textContainer.textLayoutManager
        
        //
        // textContainer.replaceLayoutManager(<#T##newLayoutManager: NSLayoutManager##NSLayoutManager#>)
    }
    
    //MARK: - Defining the Container Shape
    func DefiningtheContainerShape(textContainer: NSTextContainer) {
        
        textContainer.size = CGSize(width: UIScreen.main.bounds.width, height: 200)
        
        // 路径对象数组，表示文本不显示在文本容器中的区域
//        let exclusionPaths: [UIBezierPath] = [UIBezierPath(arcCenter: CGPoint(x: 100, y: 70), radius: 30, startAngle: 0, endAngle: 90, clockwise: true)]
//        textContainer.exclusionPaths = exclusionPaths
        
        // 截断模式
        textContainer.lineBreakMode = .byTruncatingTail
        
        // 控制TextView在其文本视图调整大小时是否调整其边界矩形的宽度。默认值为 false
        textContainer.widthTracksTextView = false
        
        // 控制TextView在其文本视图调整大小时是否调整其边界矩形的高度。默认值为 false
        textContainer.heightTracksTextView = false
    }
    
    //MARK: - Constraining Text Layout
    func ConstrainingTextLayout(textContainer: NSTextContainer) {
        
        // TextView最大行数。 默认值为 0，表示没有限制。
        textContainer.maximumNumberOfLines = 0
        
        /*
         填充出现在片段的开头和结尾。 布局管理器使用此值来确定布局宽度。 此属性的默认值为 5.0。
         行片段填充并非旨在表达文本边距。 相反，您应该在文本视图上使用插图，调整段落边距属性，或更改文本视图在其父视图中的位置
         */
        textContainer.lineFragmentPadding = 5
        
        // 继承该类。重写方法可以修改显示形状， 默认是矩形，可以修改为其它形状
//        textContainer.lineFragmentRect(forProposedRect: CGRect(x: 0, y: 0, width: 130, height: 60), at: 20, writingDirection: .rightToLeft, remaining: nil)
        
        // 一个布尔值，指示文本容器的区域是否为没有孔或间隙的矩形，并且其边缘平行于文本视图的坐标系轴
        /*
         当文本容器的区域是一个没有孔或间隙的矩形并且边缘平行于文本视图的坐标系轴时，此属性的值为真。 当 excludePaths 属性包含一个或多个项目、maximumNumberOfLines 属性不为零或重写 lineFragmentRect(forProposedRect:at:writingDirection:remaining:) 方法时，此属性的默认值为 false。 否则，默认值为 true
         */
        let isSimpleRectangularTextContainer = textContainer.isSimpleRectangularTextContainer
    }
}
