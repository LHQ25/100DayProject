//
//  EncodingandDecodingOperator.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct EncodingandDecodingOperator {
    
    static var cancellable: AnyCancellable?
    
    static func loadTestOperators() {
        
        
        encodeTest()
        decodeTest()
        
    }
    
    static func encodeTest() {
        
        print("----- \("encode") -----")
        defer { print("") }
        
        // 使用指定的编码器对来自上游的输出进行编码。
        let dataProvider = PassthroughSubject<CustomData, Never>()
        let cancellable = dataProvider
            .encode(encoder: JSONEncoder())
            .sink(receiveCompletion: { print ("Completion: \($0)") },
                  receiveValue: {  data in
                    guard let stringRepresentation = String(data: data, encoding: .utf8) else { return }
                    print("Data received \(data) string representation: \(stringRepresentation)")
            })

        dataProvider.send(CustomData(name: "n1", age: 112))
    }
    
    static func decodeTest() {
        
        print("----- \("encode") -----")
        defer { print("") }
        
        // 使用指定的编码器对来自上游的输出进行编码。
        let dataProvider = PassthroughSubject<Data, Never>()
        let cancellable = dataProvider
            .decode(type: CustomData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { print ("Completion: \($0)") },
                  receiveValue: {  data in
                   print(data)
            })

        dataProvider.send(Data("{\"name\":\"n2\",\"age\":123}".utf8))
    }
    
}

struct CustomData: Codable {
    
    var name: String
    var age: Int
}
