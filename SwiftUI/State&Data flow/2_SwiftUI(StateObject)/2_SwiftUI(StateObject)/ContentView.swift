//
//  ContentView.swift
//  2_SwiftUI(StateObject)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    private var contact = Contact(name: "3", age: 3)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(contact.name)
        }
        .onTapGesture {
            // 当可观察对象的 published 属性发生更改时，SwiftUI 会更新依赖于这些属性的任何视图
            contact.name = Date().description
            
            // 可以将状态对象传递给具有 ObservedObject 属性的属性。
            // 也可以通过应用 environmentObject(_:) 修饰符将对象添加到视图层次结构的环境中
            // 使用方式就和 EnvironmentObject 一样了
            
            // 也可以使用 $ 运算符获取到状态对象属性 进行 binding。
        }
        .padding()
    }
}

/* 具有 publisher 的对象，在对象 changed 之前发出 */
class Contact: ObservableObject {

    @Published
    var name: String
    
    @Published
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
