//
//  ContentView.swift
//  SolidColor
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            ForEach(models) { item in
                
                ZStack(alignment: .center) {
                    item.color.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        Text(item.colorName)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(item.colorRGBName)
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        // 实现滚动，那么在TabView视图的基础上，还需要使用tabViewStyle修饰符进行修饰，我们使用PageTabViewStyle样式
        .tabViewStyle(PageTabViewStyle())
        // 整个屏幕都是纯色背景效果，我们使用edgesIgnoringSafeArea修饰符，将iPhone安全区域去掉
        .edgesIgnoringSafeArea(.all)
        
    }
    
    
    
    var models = [
        Model(colorName: "草莓红", color: Color(red: 228/255, green: 45/255, blue: 68/255), colorRGBName: "#E42D44"),
        Model(colorName: "奶油白", color: Color(red: 250/255, green: 239/255, blue: 222/255), colorRGBName: "#FAEFDE"),
        Model(colorName: "泥猴桃绿", color: Color(red: 123/255, green: 173/255, blue: 95/255), colorRGBName: "#7BAD5F"),
        Model(colorName: "小麦黄", color: Color(red: 229/255, green: 215/255, blue: 173/255), colorRGBName: "#E5D7AD"),
        Model(colorName: "板栗灰", color: Color(red: 97/255, green: 79/255, blue: 77/255), colorRGBName: "#614F4D"),
        Model(colorName: "柠檬黄", color: Color(red: 255/255, green: 216/255, blue: 0/255), colorRGBName: "#FFD800"),
        Model(colorName: "葡萄紫", color: Color(red: 91/255, green: 52/255, blue: 99/255), colorRGBName: "#5B3663"),
        Model(colorName: "青豆绿", color: Color(red: 188/255, green: 207/255, blue: 144/255), colorRGBName: "#BCCF90"),
        Model(colorName: "水蜜桃粉", color: Color(red: 246/255, green: 160/255, blue: 154/255), colorRGBName: "#F6A09A")
    ]
}



