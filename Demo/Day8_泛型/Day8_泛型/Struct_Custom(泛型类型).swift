//
//  Struct_Custom.swift
//  Day8_泛型
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//MARK: - 泛型类型   涵盖类，结构体，枚举类型，并可以与任何类型一起使用。和字典或数组相似
struct Stack<Element: Equatable> {  //泛型类型约束  pop中有 == 进行比较， 只有实现了Swift标准库定义的Equatable协议，才能运用==或!=来比较该类型的任意的两个值
    
    var items = [Element]()
    
    mutating public func push(_ item:Element){
        items.append(item)
    }
    
    mutating public func pop(_ item:Element? = nil) -> Element {
        if item == nil {
            return items.removeLast()
        }
        items = items.filter { $0 != item }
        return item!
    }
}

//MARK: - 泛型类型的扩展
//当扩展一个泛型类型的时候，我们不需要提供类型参数的列表作为此扩展定义的一部分。因为，定义泛型类型时定义好的类型参数在其扩展中依旧时可用的
extension Stack {
    var topItem : Element? {
        items.last
    }
}

