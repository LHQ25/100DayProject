//
//  Person.swift
//  Day1_1Codeable
//
//  Created by 娄汉清 on 2020/7/8.
//  Copyright © 2020 娄汉清. All rights reserved.
//

import Foundation


/**
 Codable是Encodable和Decodable协议总和的别名。所以它既能编码也能解码
 */
/// 建立模型
struct Person : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    
    ///协议方法  可以不写
    //    init(from decoder: Decoder) throws
}


enum BeerStyle : String, Codable {
    case ipa
    case stout
    case kolsch
    // ...
}

struct Beer: Decodable {
    let name: String
    let brewery: String
    let abv: Float
    let style: BeerStyle
}


struct Swifter {
    let fullName: String
    let id: Int
    let twitter: URL
    
    init(fullName: String, id: Int, twitter: URL) { // default struct initializer
        self.fullName = fullName
        self.id = id
        self.twitter = twitter
    }
}

extension Swifter: Decodable {
    ///属性映射   定义过的属性都要写
    enum MyStructKeys: String, CodingKey { // declaring our keys
        case fullName = "full_name"
        //        case id = "id"
        //        case twitter = "twitter"
        ///字段名是一致的  可以写成这样
        case id, twitter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
        let fullName: String = try container.decode(String.self, forKey: .fullName) // extracting the data
        let id: Int = try container.decode(Int.self, forKey: .id) // extracting the data
        let twitter: URL = try container.decode(URL.self, forKey: .twitter) // extracting the data
        
        self.init(fullName: fullName, id: id, twitter: twitter) // initializing our struct
    }
}

struct Swifter2: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
}


///枚举类型
struct Swifter3: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
}

enum SwifterOrBool: Decodable {
    case swifter(Swifter3)
    case bool(Bool)
    
}

extension SwifterOrBool {
    enum CodingKeys: String, CodingKey {
        case swifter, bool
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let swifter = try container.decodeIfPresent(Swifter3.self, forKey: .swifter) {
            self = .swifter(swifter)
        } else {
            self = .bool(try container.decode(Bool.self, forKey: .bool))
        }
        
    }
}


///嵌套结构
struct Swifter4: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
}

struct MoreComplexStruct: Decodable {
    let swifter: Swifter4
    let lovesSwift: Bool
}
