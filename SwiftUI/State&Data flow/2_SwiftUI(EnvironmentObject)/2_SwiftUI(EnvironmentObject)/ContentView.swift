//
//  ContentView.swift
//  2_SwiftUI(EnvironmentObject)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    
    private var contact = Contact(name: "3", age: 3)
    
    var body: some View {
        VStack {
            ChildView()
                .onTapGesture {
                    contact.name = "change" + Date().debugDescription
                }
        }
        // 1. 设置 值
        .environmentObject(contact)
        .padding()
    }
}

struct ChildView: View {
    
    // 2.
    /* 由父视图或祖先视图提供的可观察对象的属性包装器类型 */
    // 可以直接使用 父视图 environmentObject(:) 设置的 对象。 有点类似于 当前 视图层级的全局变量
    @EnvironmentObject
    private var contact: Contact
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(contact.name)
        }
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

