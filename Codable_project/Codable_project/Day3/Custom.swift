//
//  Custom.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation

struct Custom {
    

    
    static func Decodertest() -> Self? {
        
        let jsonStr = """
    {
        "points": ["KSQL", "KWVI"],
        "KSQL": {
            "code": "KSQL",
            "name": "San Carlos Airport"
        },
        "KWVI": {
            "code": "KWVI",
            "name": "Watsonville Municipal Airport"
        }
    }
    """
        // "points" 键对应的是存储字符串值的数组，里面存储的字符串对应的是同一级的其他对象。
        // 对于某些语言来说这种结构解析起来比较轻松，但对 Codable 来说却没那么简单。但是，这样设计数据结构不是全无道理的
        
        let jsonData = jsonStr.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(Route.self, from: jsonData!)
            print("解码->", model)
        } catch {
            print(error)
        }

        return nil
    }
}

struct Route: Codable {
    
    struct Airport: Codable {
        var code: String
        var name: String
    }
    
    var points: [Airport]
    
    
    // 这种情况下我们不使用整数作为键，而是要去满足协议要求的实现
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RouteCodingKeys.self)

        var points: [Airport] = []
        let codes = try container.decode([String].self, forKey: .points)

        // 这里可以用 map(_:) 方法代替 for-in 循环来初始化 points，代码会更简洁
        for code in codes {
            let key = RouteCodingKeys(stringValue: code)
            let airpoint = try container.decode(Airport.self, forKey: key!)
            points.append(airpoint)
        }
        self.points = points
    }


}

// CodingKeys 也可以通过用 Int 或 String 初始化的结构来实现
struct RouteCodingKeys: CodingKey {
    
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { nil }
    
    init?(intValue: Int) {
        return nil
    }
    
    static let points = RouteCodingKeys(stringValue: "points")!
}
