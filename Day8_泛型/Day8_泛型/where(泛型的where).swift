//
//  where(泛型的where).swift
//  Day8_泛型
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//where闭包能要求关联类型必须遵守某个特定的协议，或特定的类型参数与关联类型必须相等。where闭包以where关键字开始，
//后跟关联类型的约束或类型参数与关联类型之间的相等关系。我们可以在类型或函数主体的大括号前写一个通用的where子句来设置我们的约束。
//以匹配两个容器是否相等的功能举例来阐述
func twoContainerIsEqual<C1: Container, C2: Container>(_ someContainer : C1, _ anotherContainer : C2) -> Bool where C1.Item == C2.Item, C2.Item : Equatable {
    /*
     where闭包对于关联类型的约束：
     1.容器元素类型一致，
     2.元素的类型遵守`Equatable`协议
     */
    if someContainer.count != anotherContainer.count {
        return false
    }
    
    for i in 0 ..< someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}

//MARK: - where闭包可以作为泛型扩展的一部分
extension Stack where Element: Equatable {
    
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

//MARK: - where闭包可以作为协议扩展的一部分
/*
协议通过扩展可以为遵守协议的类型提供方法，初始化，下
标和计算属性的实现。这一点允许我们为协议本身定义行
为，而不是基于遵守协议的每个类型
*/
extension Container where Item: Equatable {
//若`startsWith`函数名不与`container`中要求重名，则`startsWith`便是为遵守此协议的类型增加了新的方法。
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

//MARK: - where闭包，可以要求Container协议Item为特定类型
//extension Container where Item == Double {
//    func average() -> Double {
//        var sum = 0.0
//        for index in 0..<count {
//            sum += self[index]
//        }
//        return sum / Double(count)
//    }
//}


//MARK: -
//MARK: - 关联类型使用泛型 where闭包
protocol Container2 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator : IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}
//构建迭代器
struct Iterator<T> : IteratorProtocol {
    
    var stack : Stack2<T>
    var count = 0
    
    init(_ stack : Stack2<T>) {
        self.stack = stack
    }
    
    typealias Element = T

    mutating func next() -> T? {
        let next = stack.count - 1 - count
        guard next >= 0 else {
            return nil
        }
        count += 1
        return stack[next]
    }
}
//我们的泛型`Stack`需要实现`Sequence`协议
struct Stack2<Element> : Container2, Sequence {
    
    //container只能用作泛型约束。
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
    //迭代器的实现
    typealias IteratorType = Iterator<Element>
    func makeIterator() -> IteratorType {
        return Iterator.init(self)
    }
}

//MARK: - 泛型下标
extension Container2 {
    
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {  //Indices.Iterator.Element == Int保证了序列中的索引与用于容器的索引具有相同的类型。即：意味着为索引参数传递的值是整数序列
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
