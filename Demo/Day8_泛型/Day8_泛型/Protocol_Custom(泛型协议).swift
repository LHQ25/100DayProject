//
//  Protocol_Custom.swift
//  Day8_泛型
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//MARK: - 协议使用类型关联
/**
    当我们定义协议时，有时声明一个或多个关联类型作为协议定义的一部分是很有用的。 关联类型的作用，主要提供某个类型的占位名称，然后作为协议的一部分去使用。关联类型的实际使用类型直到协议被实现时才会指定。关联类型使用关键字associatedtype指定
 */
protocol Container {
    
    associatedtype Item // 添加约束到关联类型
    //associatedtype Item: Equatable // 也可以对关联类型 添加约束
    
    mutating func append(_ item: Item)
    
    var count : Int {get }
    
    subscript(i: Int) -> Item{get }
    
}

//MARK: - 定义整型Stack类型  实现Container协议
struct IntStack : Container {
    
    var items = [Int]()
    
    mutating func push(_ item:Int){
        items.append(item)
    }
    
    mutating func pop(_ item:Int) -> Int {
        return items.removeLast()
    }
    
    //实现协议时，需要明确关联类型的实际类型  指明协议的关联对象是Int类型   也可以像下面方法一样指定类型
    typealias Item = Int //!< ①

    mutating func append(_ item: Item) {//!< ①若不存在，此处可直接 Int
        push(item)
    }
    
    var count: Int {
        items.count
    }
    //下标获取值
    subscript(i: Int) -> Int {
        items[i]
    }
}

//MARK: - 泛型协议
struct ContainerStack<Element> : Container {
    
    var items = [Element]()
    
    mutating func push(_ item:Element){
        items.append(item)
    }
    
    mutating func pop(_ item:Element) -> Element {
        return items.removeLast()
    }
    
    //实现协议
    typealias Item = Element
    
    //自动提示为`Element`
    mutating func append(_ item: Element) {
        push(item)
    }
    var count: Int {
        items.count
    }
    subscript(i: Int) -> Element {
        items[i]
    }
}


//MARK: 扩展现有类型以指定关联类型
//MARK: - 扩展现有类型以指定关联类型？是否成功。
/**
    Swift的Array类型已经提供了Container协议中方法，属性要求的实现，完全匹配Container协议要求。
    这意味着我们通过Array的扩展声明Array遵守Container协议，
    并且Array内部对于协议要求的实现
    可以推断出协议关联类型Item的实际类型
 */
extension Array : Container{
    
    func associateTypeOne(_: Item){
        print("associateTypeOne")
    }
    
    func associateTypeTwo(_: Element){
        print("associateTypeTwo")
    }
    
    func associateTypeThree(_: Self){
        print("associateTypeThree")
    }//实现协议时，Self都会与协议实现类型进行关联
}

//MARK: -
//MARK: - 未使用关联类型的协议Int_Container  没有使用到关联类型 或 Self 时  可以作为方法的参数类型   也可以 is 判断   否则就会报错
protocol Int_Container {
    
    mutating func append(_ item : Int)
    
    var count : Int{get}
    
    subscript(i:Int)->Int{get}
}

//MARK: - 定义函数，参数为协议类型
//func testProtocolWithAssociateTypeOne(_ parameter : Container) {

/*
    报错:Protocol 'Container' can only be used as a generic
    constraint because it has Self or associated type requirements
 */

//}
func testProtocolNoAssociatetype(_ parameter: Int_Container){
    //编译成功
}

//MARK: - 举例
//MARK: - 关联类型的协议用作泛型的约束举例：
//①
struct TempStruct<T: Container> {
    let title : String = "关联类型的协议用作泛型类型的约束：代替`T`的实际类型必须遵守`Container`协议"
    func showYourMagic(_ para : T) -> Void {
        print(para)
    }
}
//②
func showYourMagic<T>(_ para : T) {
    print(para)
}


//MARK: - 关联类型的约束中使用协议
//协议定义
//定义继承协议
protocol SuffixableContainer : Container {
    
    /*新构建的关联类型`suffix`约束条件有两个：
     1.实现此协议时指定的`suffix`的类型必须是实现`SuffixableContainer`协议的类型
     2.此`suffix`占位的容器类型的存储项类型`Item`必须与当前实现此协议的存储项保持一致。
     */
    associatedtype suffix : SuffixableContainer where suffix.Item == Item
    
    /*`item`关联类型的实际类型由泛型类型的占位类型决定。
     此方法必须确保`String`类型的容器，截取的后缀，重组后的容器仍然是`String`类型的*/
    func suffix(_ size : Int) -> suffix
    
}
//实现

extension IntStack : SuffixableContainer {
    
    func suffix(_ size: Int) -> IntStack {
        var result = IntStack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}
