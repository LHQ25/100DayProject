//
//  DateFormatter.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation

struct DateFormatter {
    
    static func Decodertest() -> Self? {
        
        let jsonStr = """
    {
        "aircraft": {
            "identification": "NA12345",
            "color": "Blue/White"
        },
        "flight_rules": "IFR",
        "route": ["KTTD", "KHIO"],
        "departure_time": {
            "proposed": "2018-04-20T14:15:00-0700",
            "actual": "2018-04-20T14:20:00-0700"
        },
        "remarks": null
    }
    """
        
        let jsonData = jsonStr.data(using: .utf8)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let model = try decoder.decode(FlightPlan.self, from: jsonData!)
            print("解码->", model)
        } catch {
            print(error)
        }

        return nil
    }
}

struct FlightPlan: Codable {
    var aircraft: Aircraft              // 键 "aircraft" 时，它就会去调用和这个键有关的 init(from:) 初始化方法来解析里面的 JSON 并创建一个新的 Aircraft 值，然后把这个值设置到 aircraft 属性里
    var flightRules: FlightRules        // 从字符串中解析枚举类型: FlightRules 枚举的原始类型是 String。设定原始类型以及在定义中声明 Codable，不需要写任何额外的代码, 值是额外的其他值，会解析失败
    var route: [String]                 // 解析字符串数组: Swift 自动解析包含 decodable 对象的数组，同样，其实也可以解析数组型的属性
    //var departureDates: [String: Date]// 把时间戳解析成日期类型: JSONDecoder 提供解析日期类型，无论数据是如何表示的。根据需求设置一下 dateDecodingStrategy 属性
    var remarks: String?                // 使用默认值或 Optional 对象来解析空值
    
    // 把 departureDates 设置成 private，这样就隐藏了实现的细节，对调用者仅暴露 proposedDepartureDate 和 actualDepartureDate 属性
    private var departureDates: [String: Date]
    
    var proposedDepartureDate: Date? {
        return departureDates["proposed"]
    }

    var actualDepartureDate: Date? {
        return departureDates["actual"]
    }

}

/// 处理键名和属性名称不匹配的情况
/// 或者
/// var decoder = JSONDecoder()   decoder.keyDecodingStrategy = .convertFromSnakeCase  下划线改为驼峰法
extension FlightPlan {
    
    private enum CodingKeys: String, CodingKey {
        case aircraft
        case flightRules = "flight_rules"
        case route
        case departureDates = "departure_time"
        case remarks
    }
}

struct Aircraft: Codable {
    var identification: String
    var color: String
}

enum FlightRules: String, Codable {
    case visual = "VFR"
    case instrument = "IFR"
}
