//
//  ContentView.swift
//  4_SwiftUI(SceneStorage)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

/* 一种属性包装器类型，用于读写持久化的、每个场景的存储 */
struct ContentView: View {
    
    @SceneStorage("Scene_Name_key")
    var name: String?
    
    @SceneStorage(wrappedValue: 111, "Scene_Age_key")
    var age: Int
    
    // 用法和 AppStorage 一样
    
    /*
     当需要自动恢复值的状态时，可以使用SceneStorage。
     SceneStorage的工作原理与State非常相似，除了它的初始值是由系统恢复的，
     如果它之前被保存过，并且该值与同一场景中的其他SceneStorage变量共享。
     
     系统不能保证何时以及多长时间保存数据。
     
     每个场景都有自己的SceneStorage概念，因此数据不会在场景之间共享。
     确保与SceneStorage一起使用的数据是轻量级的。大数据，例如模型数据，不应该存储在SceneStorage中，因为可能会导致性能下降。
     */
    
    var body: some View {
        
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text(name ?? "e")
            
            Text("\(age)")
            
        }
        .padding()
    }
}
