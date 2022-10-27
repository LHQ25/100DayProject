//
//  ContentView.swift
//  4_SwiftUI(AppStorage)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

/* 一种属性包装器类型，它反映来自 UserDefaults 的值，并使该用户默认值中的值更改的视图无效 */
struct ContentView: View {
    
    // 可选值
    @AppStorage("name_key", store: .standard)
    var name: String?
    
    // 有默认值
    @AppStorage(wrappedValue: 123, "age_key", store: .standard)
    var age: Int
    
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("\(name ?? "") - \(age)")
            
            Button("action") {
                name = "action"
            }
            
            Button("action2") {
                name = "action2"
            }
            
        }
        .padding()
    }
}
