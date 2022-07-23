//
//  CardView.swift
//  SwiftUIBanner
//
//  Created by 9527 on 2022/7/16.
//

import SwiftUI

/*
 GeometryReader几何容器，将我们的Image图片和Text文字包裹在里面。而且图片的大小.frame修饰符中，设置的Image图片尺寸是我们GeometryReader几何容器宽高。
 GeometryReader几何容器简单来说，就是一个View，但不同的是，它的宽高是通过自动判断你的设备的屏幕尺寸的定的。这样，假设我们有一张4000*4000分辨率的图片的时候，我们就不用再设置它在屏幕中展示的固定大小了，屏幕多少，里面的图片就可以自动设置多大
 */
 
struct CardView: View {
    
    var image: String
    var name: String
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { geometry in
                
                Image(self.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(16)
                    .overlay(
                        Text(self.name)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(.white)
                            .padding([.bottom, .leading])
                            .opacity(1)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                    )
            }
        }
    }
}
