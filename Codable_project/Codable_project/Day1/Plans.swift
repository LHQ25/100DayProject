//
//  Plans.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation

struct Plans {
    
    static func Decodertest() -> [Plane] {
        let plansJosn = """
        [
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
        """.data(using: .utf8)
        
        
        // 对象不总是单飞，事实上很多情况对象都被存储在数组里
        let decoder = JSONDecoder()
        if let plans = try? decoder.decode([Plane].self, from: plansJosn!) {
            print("解码->", plans)
            return plans
        }
        return []
    }
    
    // 编码
    static func encodeTest(with model: [Plane]) {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let reencodedJSON = try? encoder.encode(model) {
            print("编码->", String(data: reencodedJSON, encoding: .utf8)!)
        }
    }
}
