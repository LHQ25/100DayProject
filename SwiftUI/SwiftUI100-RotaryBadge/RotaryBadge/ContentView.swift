//
//  ContentView.swift
//  RotaryBadge
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var animation = false
    
    var body: some View {
        
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            Image(systemName: "sun.dust")
                // resizable修饰符改变其大小
                .resizable()
                // aspectRatio修饰符保持宽高比
                .aspectRatio(contentMode: .fit)
                // rame修饰符调整大小
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                // 使用clipShape将图像切割为Circle圆形
                .clipShape(Circle())
                // 使用overlay覆盖了一个lineWidth线宽为5的白色边框
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                )
                // 使用shadow给图像加了个阴影
                .shadow(radius: 20)
                .rotation3DEffect(.degrees(animation ? 360 : 0), axis: (0, 1, 0.2))
                .onTapGesture {
                    // 显示动画
                    withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                        self.animation.toggle()
                    }
                }
        }
    }
}
