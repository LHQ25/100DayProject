//
//  AnimationExample.swift
//  SwiftUI-Animation-Paths
//
//  Created by 9527 on 2022/7/28.
//

import SwiftUI

struct AnimationExample: View {
    
    @State var half = false
    @State var dim = false
    
    var body: some View {
        // 隐式动画更改图像的大小和不透明度
        GeometryReader { geometryProxy in
            VStack {
                Image("11")
                        .resizable()
                        .frame(width: geometryProxy.size.width, height: 200, alignment: .center)
                        .padding()
                        .scaleEffect(half ? 0.5 : 1)
                        .opacity(dim ? 0.2 : 1)
                        // 隐式动画是你用 .animation() 修饰符指定的那些动画。每当视图上的可动画参数发生变化时，
                        // SwiftUI 就会从旧值到新值制作动画。一些可动画的参数包括大小(size)、偏移(offset)、颜色(color)、比例(scale)等
                        .animation(.easeInOut(duration: 1))
                        .onTapGesture {
                            self.dim.toggle()
                            self.half.toggle()
                        }

                // 显示动画更改图像的大小和不透明度
                Image("11")
                    .resizable()
                    .frame(width: geometryProxy.size.width, height: 200, alignment: .center)
                    .padding()
                    .scaleEffect(half ? 0.5 : 1)
                    .opacity(dim ? 0.2 : 1)
                    .onTapGesture {
                        self.half.toggle()
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.dim.toggle()
                        }
                    }
                
                Spacer()
            }
        }
    }
}
