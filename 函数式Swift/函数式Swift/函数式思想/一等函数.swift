//
//  一等函数.swift
//  函数式Swift
//
//  Created by 9527 on 2022/8/8.
//

import Foundation

//MARK: - 一等函数

/* Region 类型将指代把 Position 转化为 Bool 的函数 */
typealias Region = (Position) -> Bool

extension Position {
    
    func positionInRange(point: Position) {
        
    }
}

/// 以原点为圆心的圆
func circle(radius: Distance) -> Region {
    return { $0.length <= radius }
}

/// 圆心是任意点的圆
func circle(radius: Distance, center: Position) -> Region {
    return { $0.minus(center).length <= radius }
}

/// 为了避免创建像 circle2 这样越来越复杂的函数，我们编写了一个 shift(_:by:) 函数来改变另一个函数
func shift(_ region: @escaping Region, by offset: Position) -> Region {
    return { region($0.minus(offset)) }
}

/// 通过反转一个区域以定义另一个区域。这个新产生的区域由原区域以外的所有点组成
func invert(_ regoin: @escaping Region) -> Region {
    return { !regoin($0) }
}

// 交集
func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
    { region($0) && other($0) }
}

// 并集
func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
    { region($0) || other($0) }
}

// difference 函数接受两个区域作为参数 —— 原来的区域和要减去的区域 —— 然后为所有在第一个区域中且不在第二个区域中的点构建一个新的区域
func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
    intersect(original, with: invert(region))
}


extension Ship {
    
    func canSafelyEngage3(ship tagert: Ship, friendly: Ship) -> Bool {
        
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        
        return resultRegion(tagert.position)
    }
}
