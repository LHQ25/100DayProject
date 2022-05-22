//
//  BattleshipModel.swift
//  Swift函数式编程
//
//  Created by 9527 on 2022/5/20.
//

import Foundation

typealias Distance = Double

struct Position {
    
    var x: Double
    var y: Double
}

extension Position {
    
    ///  检查是否在范围内
    func within(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}


struct Ship {
    
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    
    // 范围内是否有另一条船
    func canEngage(ship target: Ship) -> Bool {
        
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    func canSafelyEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}
