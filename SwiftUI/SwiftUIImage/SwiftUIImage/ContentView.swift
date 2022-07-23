//
//  ContentView.swift
//  SwiftUIImage
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            Image("8")
                .resizable()                                    // 缩放
                .edgesIgnoringSafeArea(.all)                    // 去除安全区
            //.scaledToFit()                                // 等比例缩放
                .aspectRatio(3/4, contentMode: .fit)            // 设置纵横比 可以达到同样的 缩放
                .frame(width: 350)                              // 设置frame
                .clipShape(Circle())                            // 裁剪 圆形
                .opacity(0.8)                                   // 透明度
                .overlay {                                      // 在图片视图上再增加添加一个视图，“覆盖”在上面，我们可以用.overlay()修饰符
                    Text("编辑")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(Color.white)
                }
                .onLongPressGesture {
                    print("onLongPressGesture")
                }
            
            //使用系统图标符号
            Image(systemName:"square.and.arrow.up")
                .font(.system(size: 80))
        }
    }
}
