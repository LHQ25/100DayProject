//
//  ContentView.swift
//  Day14_1 SwiftUI(ForEach)
//
//  Created by 亿存 on 2020/7/28.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct Person: Identifiable {
    
    var id: UUID? = UUID()
    var name: String = ""
    
}

struct ContentView: View {
    
    var data = [Person(name: "t1"), Person(name: "t2"), Person(name: "t3")]
    
//    func action() {
//
//        ForEach(data){
//            print($0.name)
//        }
//
//    }
    
    var body: some View {
        VStack{
            VStack{
                //创建一个实例，该实例在给定的恒定范围内按需计算视图
                ForEach(0..<3){
                    Text("Hello, World! -\($0)")
                }
                
                //这样写  需要Person 遵守协议 Identifiable， 并实现一个 id 属性
                ForEach(data){
                    Text("Hello, World! -\($0.name)")
                }
                
                // 设置动态视图的删除操作
                ForEach(data){
                    Text("Hello, World! -\($0.name)")
                }.onDelete { (indexSet) in
                    
                }
                
            }
            
            VStack{
                //设置动态视图的移动动作。
                ForEach(data){
                    Text("Hello, World! -\($0.name)")
                }.onMove { (indexSet, idx) in
                    
                }
                
                ///已废弃  动态视图的插入操作。
//                ForEach(data){
//                    Text("Hello, World! -\($0.name)")
//                }.onInsert(of: ["999"]) { (idx, itemProvider) in
//
//                }
                
                //新
//                func onInsert(of: [UTType], perform: (Int, [NSItemProvider]) -> Void) -> some DynamicViewContent
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
