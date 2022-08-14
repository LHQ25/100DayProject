//
//  Battleship.swift
//  函数式Swift
//
//  Created by 9527 on 2022/8/8.
//

import Foundation

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    
    // 是否在可攻击范围内
    func withIn(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

extension Position {
    
    func minus(_ p: Position) -> Position {
        
        return Position(x: x - p.x, y: y - p.x)
    }
    
    /// 半径 可攻击范围
    var length: Double {
        sqrt(x * x + y * y)
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    
    // 可攻击
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    // 安全范围内
    func canSafelyEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
    
    // 友方参与
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > friendly.unsafeRange
    }
    
    // 优化后
    func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
        
        let targetDistance = target.position.minus(position).length
        
        let friendlyDistance = friendly.position.minus(target.position).length
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > friendly.unsafeRange
    }
}
