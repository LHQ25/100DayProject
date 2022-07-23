//
//  ContentView.swift
//  UIText
//
//  Created by 9527 on 2022/7/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .fontWeight(.bold)                  // 字重
            .font(.title)                       // 字体样式
            .font(.system(size: 17))            // 字体大小
            .foregroundColor(.red)              // 字体颜色
            .shadow(color: .blue, radius: 4)    // 阴影
            .background(.yellow)                // 背景颜色
            .padding()                          // 边距
    }
}

