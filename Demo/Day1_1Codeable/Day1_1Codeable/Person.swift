//
//  Person.swift
//  Day1_1Codeable
//
//  Created by 娄汉清 on 2020/7/8.
//  Copyright © 2020 娄汉清. All rights reserved.
//

import Foundation

class myCodingKey: NSObject, CodingKey {
    
    var stringValue: String{
        get{
            return v
        }
    }
    
    var intValue: Int?{
        get{
            return i
        }
    }
    
    private var v:String!
    private var i: Int?
    required init?(stringValue: String){
        v = stringValue
    }
    
    required init?(intValue: Int) {
        i = intValue
    }
}

/**
 Codable是Encodable和Decodable协议总和的别名。所以它既能编码也能解码
 */
/// 建立模型   基础
struct Person : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    
    ///协议方法  可以不写
    //    init(from decoder: Decoder) throws
}

struct Person2 : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    
    ///日期
    let date: Date?
    ///时间戳
    let time: Date?
    ///毫秒 时间戳
    let millTime: Date?
}
//MARK: - 属性映射  方式一
struct Person3 : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    
    let firstName: String
    let _lastName_: String
    
    //属性每一个都要写到里面,  也可以不写，但要实现Decoder协议的方法,  枚举的名称 要为这个 CodingKeys，否则找不到对应的数据
    enum CodingKeys: String, CodingKey {
        case fullName , id , twitter
        case firstName = "first_name"
        case _lastName_ = "_last_name_"
    }
}

struct Person5 : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    
    let name: Data
}

//MARK: - 属性映射  方式二
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


struct Person4 : Decodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    let num: Float
}


//MARK: - 枚举 属性
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
struct Swifter5: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case fullName, id, twitter
        case firstName = "first_name"
    }
}

struct MoreComplexStruct: Decodable {
    let swifter: Swifter4
    let lovesSwift: Bool
    let swifter_list: [Swifter5]
}


//MARK: - 解码
struct People : Encodable {
    
    let fullName: String
    let id: Int
    let twitter: URL
    var birthday: Date?
    
    ///协议方法  可以不写
    //    init(from decoder: Decoder) throws
    
    init(name: String, i: Int, tw: URL) {
        fullName = name
        id = i
        twitter = tw
    }
}

struct People_list : Encodable {
    
    let list: [People]
    init(l:[People]) {
        list = l
    }
}

class Person6 : Codable {
    var name: String?
    
    private enum CodingKeys : String, CodingKey {
        case name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
class Employee : Person6 {
    var employeeID: String?
    
    private enum CodingKeys : String, CodingKey {
        case employeeID = "emp_id"
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(employeeID, forKey: .employeeID)
    }
}
