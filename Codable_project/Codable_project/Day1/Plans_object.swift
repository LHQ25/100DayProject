//
//  Plans_object.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation

struct Fleet: Codable {
    var planes: [Plane]
}

struct Plans_Object {
    
    static func Decodertest() -> Fleet? {
        let plansJosn = """
        {
            "planes": [
                {
                    "manufacturer": "Cessna",
                    "model": "172 Skyhawk",
                    "seats": 4
                },
                {
                    "manufacturer": "Piper",
                    "model": "PA-28 Cherokee",
                    "seats": 4
                }
            ]
        }
        """.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        // Swift 中标记为 throws 关键词的初始化方法和普通函数都可能报错而不是返回一个值。
        // Decodable 的初始化方法 init(from:) 和 Encodable 的 encode(to:) 方法都标记有 throws 关键词 —— 这样设计很合理，因为这两个操作都有可能不成功。
        // 解析的时候输入的数据可能被破坏了，也可能键丢失了，或者写错了，或者要求非空值但缺少了。 编码的时候这些问题都会出现，没什么特征，但都和要求的格式不符。
        
        do {
            let fleet = try decoder.decode(Fleet.self, from: plansJosn!)
            print("解码->", fleet)
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    // 编码
    static func encodeTest(with model: Fleet) {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let reencodedJSON = try encoder.encode(model)
            print("编码->", String(data: reencodedJSON, encoding: .utf8)!)
        } catch  {
            print(error)
        }
    }
}
