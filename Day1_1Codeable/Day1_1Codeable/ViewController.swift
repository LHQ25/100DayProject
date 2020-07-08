//
//  ViewController.swift
//  Day1_1Codeable
//
//  Created by 娄汉清 on 2020/7/8.
//  Copyright © 2020 娄汉清. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        baseDecodable()
        //        decodable2()
        
        //        decodable3()
        
        //        dec4()
        //        dec5()
//        dec6()
        dec7()
    }
    
    func baseDecodable() {
        
        let json = """
        {
         "fullName": "Federico Zanetello",
         "id": 123456,
         "twitter": "http://twitter.com/zntfdr"
        }
        """.data(using: .utf8)! // our data in native (JSON) format
        
        do {
            let myStruct = try JSONDecoder().decode(Person.self, from: json) // Decoding our data
            print(myStruct) // decoded!!!!!
        }catch(let error){
            print(error.localizedDescription)
        }
        
    }
    
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
    
    func decodable3() {
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
    
    func dec7(){
        let json = """
        {
            "swifter": {
                "fullName": "Federico Zanetello",
                "id": 123456,
                "twitter": "http://twitter.com/zntfdr"
            },
            "lovesSwift": true
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
}

