//
//  ViewController.swift
//  InputViewDemo
//
//  Created by 9527 on 2022/7/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        

        configuringTextAttributes()
        
        managingtheEditingBehavior()
        
        WorkingwiththeSelection()
        
        ReplacingtheSystemInputViews()
        
        AccessingTextKitObjects()
    }


}


extension ViewController {
    
    //MARK: - Configuring the Text Attributes
    
    func configuringTextAttributes() {
        

        
        // textView.attributedText
        textView.text = """
find 命令是 Linux 命令中最有用的命令之一，它的功能非常强大，且语法复杂。其实我们不一定需要了解它的所有细节，掌握上述实战案例中的常见用法，足够满足日常工作中的大部分需求。
下边我们一起来总结下 find 命令常见用法，加深对 find 使用方法的理解。
命令格式
find path -option [-exec ...]
按文件名查找
https://www.baidu.com   18637683265

-name：按照文件名称查找，准确匹配；
-iname：不区分文件名的大小写；
-inode：按照文件 inode 号查找；

按照文件类型查找
按照文件类型查找，可以使用 -type 选项，具体支持的文件类型如下：

f：普通文件
d：目录文件
l：链接文件
s：套接字文件
p：管道文件
b：块设备文件，比如：磁盘
c：字符设备文件，比如：键盘、鼠标、网卡
"""
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .black
        
        // 在文本视图中转换为可点击 URL 的数据类型
        textView.dataDetectorTypes = .all
        // 应用于链接的属性。
        textView.linkTextAttributes = [.foregroundColor: UIColor.cyan, .font: UIFont.systemFont(ofSize: 16)]
        
        // 应用于用户输入的新文本的属性。
        textView.typingAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 16)]
        
        textView.textAlignment = .left
        
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // 确定文本的呈现比例
        textView.usesStandardTextScaling = true
    }
    
    //MARK: - Managing the Editing Behavior
    func managingtheEditingBehavior() {
        
        textView.isEditable = true
        
        /*
         当设置为 true 时，文本视图允许用户更改当前选定文本的基本样式。
         可用的样式选项列在编辑菜单中，并且仅适用于选择。
         此属性的默认值为 false
         */
        textView.allowsEditingTextAttributes = false
        
        // 三个通知
        // UITextView.textDidBeginEditingNotification
        // UITextView.textDidChangeNotification
        // UITextView.textDidEndEditingNotification
    }
    
    //MARK: - Working with the Selection
    func WorkingwiththeSelection() {
        
        // 当前选择范围
        let _ = textView.selectedRange
        
        // 滚动文本视图，直到指定范围内的文本可见
        textView.scrollRangeToVisible(NSRange(location: 20, length: 7))
        
        textView.clearsOnInsertion = false
        
        // 文本是否可选
        // 控制用户选择内容以及与 URL 和文本附件交互的能力。 默认值是true
        textView.isSelectable = true
    }
    
    //MARK: - Replacing the System Input Views
    func ReplacingtheSystemInputViews() {
        
        // TextView成为第一响应者时显示的自定义输入视图
        textView.inputView = nil
        // TextView成为第一响应者时显示的自定义附件视图
        textView.inputAccessoryView = nil
    }
    
    //MARK: - Accessing TextKit Objects
    func AccessingTextKitObjects() {
        
        // UITextView容器的布局管理器
        let layoutManager = textView.layoutManager
        
        // UITextView容器显示的区域的文本容器对象
        let textContainer = textView.textContainer
        
        // UITextView容器中显示的文本的文本存储对象
        let a = textView.textStorage
    }
}


extension ViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        print("textViewShouldBeginEditing")
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        print("textViewDidBeginEditing")
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        print("textViewDidEndEditing")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("shouldChangeTextIn")
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print("textViewDidChange")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        print("textViewDidChangeSelection")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("shouldInteractWith: URL: characterRange: interaction")
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        print("shouldInteractWith: textAttachment: characterRange: interaction")
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("shouldInteractWith: shouldInteractWith: characterRange")
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        print("shouldInteractWith: textAttachment: characterRange")
        return true
    }
}
