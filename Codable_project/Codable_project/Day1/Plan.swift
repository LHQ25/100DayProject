//
//  Plan.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation

struct Plane: Codable {
    
    var manufacturer: String
    var model: String
    var seats: Int
    
    // 创建一个 CodingKeys 枚举，定义属性名称和容器的键之间的映射。
    // 这个枚举声明其原始类型是 String，同时声明使用 CodingKey 协议。
    // 因为每个名字都和 JSON 中的键相同，所以我们不用为这个枚举提供明确的原始值
    enum CodingKeys: String, CodingKey {
        case manufacturer, model, seats
    }
    
    // 在 init(from:) 初始化函数里我们创建一个键控容器，调用 decoder 的 container(keyedBy:) 方法，并传入 CodingKeys 作为参数
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        model = try container.decode(String.self, forKey: .model)
        seats = try container.decode(Int.self, forKey: .seats)
    }
    
    /// 解码
    static func Decodertest() -> Self? {
        let planJson = """
        {
            "manufacturer": "Cessna",
            "model": "172 Skyhawk",
            "seats": 4
        }
        """.data(using: .utf8)
        
        let decoder = JSONDecoder()
        if let plan = try? decoder.decode(Plane.self, from: planJson!) {
            print("解码->", plan)
            return plan
        }
        return nil
    }
    
    // 先调用 encoder 的 container(keyedBy:) 方法创建一个 container， 和上一步一样，传入一个 CodingKeys.self 参数。
    // 这里我们把 container 当作一个变量（使用 var 而不是 let），
    // 因为这个方法做的是填充 encoder 的参数，需要进行修改。我们对每个属性调用一次 encode(_:forKey:) 并传入属性的值和它对应的键
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(model, forKey: .model)
        try container.encode(seats, forKey: .seats)
        
    }
    
    // 编码
    static func encodeTest(with model: Self) {
        
        let encoder = JSONEncoder()
        // JSON 对空格和空行（whitespace）不敏感，但是你可能会在意。如果你觉得输出不美观，把 JSONEncoder 的 outputFormatting 属性设置为 .prettyPrinted 就好了
        encoder.outputFormatting = .prettyPrinted
        
        if let reencodedJSON = try? encoder.encode(model) {
            print("编码->", String(data: reencodedJSON, encoding: .utf8)!)
        }
    }
    
}



