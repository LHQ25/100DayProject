//
//  ContentView.swift
//  SwiftUIGradient
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                // 操作
                print("登录成功")
            }) {
                // 按钮样式
                Text("微信登录")
                    .font(.system(size: 14))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    //.background(LinearGradient(colors: [Color("8FD3F4"), Color("84FAB0")], startPoint: .leading, endPoint: .trailing)) // 渐变色
                    .padding(.horizontal, 20)
            }
            .padding()
            .buttonStyle(GradientBackgroundStyle())
            
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .background(LinearGradient(colors: [Color("8FD3F4"), Color("84FAB0")], startPoint: .leading, endPoint: .trailing))
                .border(.blue, width: 5)
                .padding()
        }
    }
}

// MARK: - 封装一个按钮协议
struct GradientBackgroundStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .background(RadialGradient(colors: [Color("8FD3F4"), Color("84FAB0")], center: .center, startRadius: 1, endRadius: 90))
            .background(LinearGradient(colors: [Color("8FD3F4"), Color("84FAB0")], startPoint: .leading, endPoint: .trailing)) // 渐变色
            .cornerRadius(5)
    }
    
}
