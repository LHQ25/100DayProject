//
//  ContentView.swift
//  SwiftUI(PasteButton)
//
//  Created by 9527 on 2022/9/23.
//
import UniformTypeIdentifiers
import SwiftUI

/* 系统按钮，用于从 粘贴板 上读取 并将其传递给闭包 */
struct ContentView: View {
    
    @State private var pastedText: String = "1234"
    
    var body: some View {
        VStack {
            
            /// 接收指定类型
            PasteButton(payloadType: String.self) { strings in
                
                pastedText = strings[0]
            }
            Divider()
            
            Text(pastedText)
            Spacer()
            
            // 指定的 UTType 类型
            PasteButton(supportedContentTypes: [UTType.avi]) { provider in
                
            }
        }
        .padding()
    }
}
