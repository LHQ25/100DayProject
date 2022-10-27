//
//  ContentView.swift
//  SwiftUI(RenaneButton)
//
//  Created by 9527 on 2022/9/23.
//

import SwiftUI

/* 触发标准重命名操作的按钮 */

struct ContentView: View {
    
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                TextField(text: $text) {
                    Text("Prompt")
                }
                .focused($isFocused)
//                .contextMenu{
//                    RenameButton()
//                }
//                .renameAction {
//                    isFocused = true
//                }
            }
            .padding()
            .navigationTitle(text)
            // 可以在导航标题菜单中使用此按钮，导航标题修饰符会使用适当的重命名操作自动配置环境
            .navigationBarItems(trailing: RenameButton())
            .renameAction {
                isFocused = true
            }
        }

    }
}
