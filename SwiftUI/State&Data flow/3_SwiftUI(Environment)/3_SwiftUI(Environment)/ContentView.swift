//
//  ContentView.swift
//  3_SwiftUI(Environment)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ChildView()
        }
        .font(Font.system(size: 30))
        // 可以使用 environment(_:_:) 视图修饰符覆盖其中的一些系统属性，以及设置您定义的自定义环境值。
        .environment(\.myCustomValue, "MyCustomValue")
        .padding()
    }
}


struct ChildView: View{
    
    // 读取属性
    @Environment(\.myCustomValue) var name
    
    // 系统的环境变量， 类似的还有很多
    @Environment(\.font) var cfont
    
    @Environment(\.keyboardShortcut) var xx
    
    @Environment(\.isEnabled) var yy
    
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(name)
                .font(cfont)
        }
    }
}


/* 用于访问环境中的值的键 */
private struct MyEnvironmentKey: EnvironmentKey {
    // 声明一个新的 key 类型并为所需的 defaultValue 属性指定一个值
    static let defaultValue: String = "name"
}

// 通过使用新属性扩展 EnvironmentValues 结构来创建自定义环境值
extension EnvironmentValues {
    
    var myCustomValue: String {
            get { self[MyEnvironmentKey.self] }
            set { self[MyEnvironmentKey.self] = newValue }
        }
}

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
