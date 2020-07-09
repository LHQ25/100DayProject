//
//  ViewController.swift
//  Day1_1Codeable
//
//  Created by 娄汉清 on 2020/7/8.
//  Copyright © 2020 娄汉清. All rights reserved.
//

import UIKit

extension JSONDecoder {
 
    
    static func hq_baseDecode<T: Decodable>(jsonStr: String , type: T.Type) -> T? {
        //转成Data类型
        let jsonData = jsonStr.data(using: .utf8)!
        do {
            return try JSONDecoder().decode(type, from: jsonData) // Decoding our data
        }catch(let error){
            print("转换类型错误： \(error.localizedDescription)")
            return nil
        }
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        
        //MARK: - 解码
//        baseDecodable()  //基础
//        propertyDateDecoder()  // 日期类型
//        propertyKeyDecoder()  // 键值映射
//        propertyKeyDecode2() // 键值映射 2
//        propertynonConformingFloatDecoder()  //处理数字异常
//        propertyDataDecoder()
//        decodable2() //枚举属性
        
        //        dec4()  //数组类型
        //        dec5()  //字典类型
//        dec6() //枚举类型
//        dec7() //嵌套结构
        
        //MARK: - 编码
        encodable1()
        encodable2()
        encodeable3()
    }
    
    //MARK: - 基础类型转换
    func baseDecodable() {
        
        let json = """
        {
         "fullName": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        }
        """
        let model = JSONDecoder.hq_baseDecode(jsonStr: json, type: Person.self)
        print(model?.fullName ?? "")
        
    }
    
    //属性分析
    func propertyDateDecoder() {
        let json = """
        {
         "fullName": "Federico Zanetello",
         "name": "swift",
         "date": "2017-11-02",
         "time": "1594259860000",
         "millTime": "1592259860876",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        }
        """
        //转成Data类型
        let jsonData = json.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .deferredToDate //默认
            //decoder.dateDecodingStrategy = .secondsSince1970   //时间戳 秒   不推荐 无法确定时区
//            decoder.dateDecodingStrategy = .millisecondsSince1970 //时间戳 毫秒   不推荐 无法确定时区
            
            ///数据中的日期为  要为指定格式的，时间戳是无法进行转换成功的    数据： "date": "2017-11-02",
//            let f = DateFormatter()
//            f.locale = Locale(identifier: "en_CN")
//            f.dateFormat = "yyyy-MM-dd"
//            decoder.dateDecodingStrategy = .formatted(f)
            
            
            ///自定义转换格式的  最好数据类型统一     否则取值的时候无法正确判断，导致转换不成功，  这里的时间戳也转成了String类型
            let formatter = DateFormatter()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                print(container)
                let dateString = try container.decode(String.self)

                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                formatter.dateFormat = "yyyy-MM-dd"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                if dateString.count == 10 || dateString.count == 13 {
                    return Date(timeIntervalSince1970: Double(Int(dateString)!))
                }
                throw DecodingError.dataCorruptedError(in: container,
                    debugDescription: "Cannot decode date string \(dateString)")
            })
            
            let model = try decoder.decode(Person2.self, from: jsonData) // Decoding our data
            
            let userInfo = decoder.userInfo
            print(userInfo)
            
            print(model)
        }catch(let error){
            print("转换类型错误： \(error)")
        }
        
    }
    func propertyKeyDecoder() {
        let json = """
                {
                 "fullName": "Federico Zanetello",
                 "first_name": "Jack",
                 "_last_name_": "Luccy",
                 "id": 123456,
                 "twitter": "http://twitter.com/zntfdr"
                }
                """
                //转成Data类型
                let jsonData = json.data(using: .utf8)!
                do {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .useDefaultKeys  //默认  根据属性名进行转换
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase // For example:  one_two_three -- >  oneTwoThree ;   _one_two_three_  -->  _oneTwoThree_ 。 简单来说就是在  驼峰和下划线 中转换
                    //当然也可以自定义转换
//                    decoder.keyDecodingStrategy = .custom({ (keys) -> CodingKey in
//                        let lastKey = keys.last!
//
//                        print(keys,lastKey)
//                        guard lastKey.intValue == nil else { return lastKey }
//                        // 去掉id 后面的  ^符号
//                        if lastKey.stringValue == "first_name" {
//                            return myCodingKey(stringValue: String("firstName"))!
//                        }else if lastKey.stringValue == "_last_name_" {
//                            return myCodingKey(stringValue: String("_lastName_"))!
//                        }else if lastKey.stringValue.contains("^") {
//                            let sv = lastKey.stringValue.dropLast().lowercased()
//                            return myCodingKey(stringValue: sv)!
//                        }else{
//                            return lastKey
//                        }
////                        return AnyKey(stringValue: stringValue)!
//                    })
                    
                    // 第三种放松  在属性里面  定义一个枚举,实现CodingKey协议
                    
                    let model = try decoder.decode(Person3.self, from: jsonData) // Decoding our data
                    
                    print(model)
                }catch(let error){
                    print("转换类型错误： \(error)")
                }
    }
    func propertynonConformingFloatDecoder() {
        let json = """
                    {
                     "fullName": "Federico Zanetello",
                     "id": 123456,
                     "twitter": "http://twitter.com/zntfdr",
                     "num": 98.6789025934
                    }
                    """
        //转成Data类型
        let jsonData = json.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            //decoder.nonConformingFloatDecodingStrategy = .throw //默认   直接抛出异常
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "infinity", negativeInfinity: "-infinity", nan: "nan")
            let model = try decoder.decode(Person4.self, from: jsonData) // Decoding our data
            
            print(model)
            
        }catch(let error){
            print("转换类型错误： \(error)")
        }
    }
    func propertyDataDecoder(){
        let json = """
                {
                 "fullName": "Federico Zanetello",
                 "name": "MTIzYWRl",
                 "id": 123456,
                 "twitter": "http://twitter.com/zntfdr"
                }
                """
                //转成Data类型
                let jsonData = json.data(using: .utf8)!
                do {
                    let decoder = JSONDecoder()
//                    decoder.dataDecodingStrategy = .deferredToData  //需要数组类型的 数据 "name": [11,22,33,44,55],
//                    decoder.dataDecodingStrategy = .base64  //需要数组类型的 数据 "name": "MTIzYWRl",   MTIzYWRl --> 123ade
                    decoder.dataDecodingStrategy = .custom({ (decoder) -> Data in
                        print("23\n")
                        let singleContainer = try decoder.singleValueContainer()
                        let d: String = try singleContainer.decode(String.self)
                        return Data(base64Encoded: d)!
                    })
                    
                    let model = try decoder.decode(Person5.self, from: jsonData) // Decoding our data
                    
                    print(model)
                    
                    print(String(data: model.name, encoding: .utf8) ?? "未知数据") //base64
                }catch(let error){
                    print("转换类型错误： \(error)")
                }
    }
    
    //枚举属性
    func decodable2() {
        /**
         如果后端没有啥特别的字段，你只需要把JSON里的Key作为Property即可。
         解析的条件就是，只要是系统提供的如String，number，Bool以及各类集合，只要是符合Decodable协议即可
         */
        let json = """
        {
            "name": "Endeavor",
            "abv": 8.9,
            "brewery": "Saint Arnold",
            "style": "ipa"
        }
        """.data(using: .utf8)! // our data in native (JSON) format
        
        do {
            let myStruct = try JSONDecoder().decode(Beer.self, from: json) // Decoding our data
            print(myStruct) // decoded!!!!!
        } catch (let error){
            print(error.localizedDescription)
        }
        
        
    }
    
    //属性映射 第二种方式
    func propertyKeyDecode2() {
        let json = """
        {
         "full_name": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        }
        """.data(using: .utf8)! // our native (JSON) data
        do {
            let dec = JSONDecoder()
            ///编码策略  使用从蛇形转化为大写 encode时同样也可将驼峰命名法转化为下划线  funll_Name  ->  fullname
            //            dec.keyDecodingStrategy = .convertFromSnakeCase
            let myStruct = try dec.decode(Swifter.self, from: json) // decoding our data
            print(myStruct) // decoded!
        }catch (let error){
            print(error.localizedDescription)
        }
    }
    
    ///数组
    func dec4() {
        let json = """
        [{
         "fullName": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        },{
         "fullName": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        },{
         "fullName": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        }]
        """.data(using: .utf8)! // our data in native format
        do {
            let myStructArray = try JSONDecoder().decode([Swifter2].self, from: json)
            
            myStructArray.forEach { print($0) } // decoded!!!!!
            print(myStructArray)
        }catch (let error){
            print(error.localizedDescription)
        }
    }
    
    ///字典
    func dec5(){
        
        let json = """
        {
          "one": {
            "fullName": "Federico Zanetello",
            "id": 123456,
            "twitter": "http://twitter.com/zntfdr"
          },
          "two": {
            "fullName": "Federico Zanetello",
            "id": 123456,
            "twitter": "http://twitter.com/zntfdr"
          },
          "three": {
            "fullName": "Federico Zanetello",
            "id": 123456,
            "twitter": "http://twitter.com/zntfdr"
          }
        }
        """.data(using: .utf8)! // our data in native format
        do {
            let myStructDictionary = try JSONDecoder().decode([String: Swifter2].self, from: json)
            
            myStructDictionary.forEach { print("\($0.key): \($0.value)") } // decoded!!!!!
            print(myStructDictionary)
        }catch (let error){
            print(error.localizedDescription)
        }
    }
    
    ///枚举类型
    func dec6() {
        let json = """
        [{
        "swifter": {
           "fullName": "Federico Zanetello",
           "id": 123456,
           "twitter": "http://twitter.com/zntfdr"
          }
        },
        { "bool": true },
        { "bool": false },
        {
        "swifter": {
           "fullName": "Federico Zanetello",
           "id": 123456,
           "twitter": "http://twitter.com/zntfdr"
          }
        }]
        """.data(using: .utf8)! // our native (JSON) data
        do{
            let myEnumArray = try JSONDecoder().decode([SwifterOrBool].self, from: json) // decoding our data
            
            myEnumArray.forEach { print($0) } // decoded!
        }catch let e{
            print(e)
        }
    }
    
    ///嵌套
    func dec7(){
        let json = """
        {
            "swifter": {
                "fullName": "Federico Zanetello",
                "id": 123456,
                "twitter": "http://twitter.com/zntfdr"
            },
            "lovesSwift": true,
            "swifter_list": [{
                "fullName": "Federico Zanetello",
                "id": 123456,
                "twitter": "http://twitter.com/zntfdr",
                "first_name":"Brus"
            },{
                "fullName": "Federico Zanetello",
                "id": 123456,
                "twitter": "http://twitter.com/zntfdr",
                "first_name":"Brus"
            },{
                "fullName": "Federico Zanetello",
                "id": 123456,
                "twitter": "http://twitter.com/zntfdr",
                "first_name":"Brus"
            }
            ]
        }
        """.data(using: .utf8)! // our data in native format
        do{
            let myMoreComplexStruct = try JSONDecoder().decode(MoreComplexStruct.self, from: json)
            
            print(myMoreComplexStruct.swifter) // decoded!!!!!
            print(myMoreComplexStruct)
        }catch let e {
            print(e)
        }
    }
    
    //MARK: - 编码
    
    func encodable1() {
        var p = People(name: "jack", i: 28, tw: URL(string: "http://www.baidu.com")!)
        
        p.birthday = Date()
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted //适合阅读类型
        //encoder.outputFormatting = .sortedKeys //根据键进行排序
        //encoder.outputFormatting = .withoutEscapingSlashes  //没有转义符的斜线
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_CN")
        f.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(f)  //此属性和解码的意思一致的  只是反过来用
        
        do{
            let data = try encoder.encode(p)
            let jsonStr = String(data: data, encoding: .utf8)
            print(jsonStr ?? "")
        }catch let e {
            print("转换失败： \(e)")
        }
    }
    
    //嵌套
    func encodable2() {
        let p1 = People(name: "jack1", i: 28, tw: URL(string: "http://www.baidu.com")!)
        let p2 = People(name: "jack2", i: 28, tw: URL(string: "http://www.baidu.com")!)
        let p3 = People(name: "jack3", i: 28, tw: URL(string: "http://www.baidu.com")!)
        
        let pp = People_list(l: [p1,p2,p3])
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted //适合阅读类型
        
        do{
            let data = try encoder.encode(pp)
            let jsonStr = String(data: data, encoding: .utf8)
            print(jsonStr ?? "")
        }catch let e {
            print("转换失败： \(e)")
        }
    }
    
    //集成的编码方式
    func encodeable3(){
        let employee = Employee()
        employee.employeeID = "emp123"
        employee.name = "Joe"

        //对象继承并不能如我们所愿可以直接编码解码
        //实现自定义编码解码方法
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted //适合阅读类型
        
        do{
            let data = try encoder.encode(employee)
            let jsonStr = String(data: data, encoding: .utf8)
            print(jsonStr ?? "")
        }catch let e {
            print("转换失败： \(e)")
        }
        
    }
}

