//
//  ContentView.swift
//  Day13_SwiftUI(View)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct RedBorderedButtonStyle: PrimitiveButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        return Button(configuration).border(Color.red)
    }
}


struct ContentView: View {
    
    var body: some View {
        ///初始化
        VStack{
            Text("Creating a button")
            VStack{
                // Available when Label is Text.
                Button("初始化1",action:  btnAction)
                //2 custom label
                Button(action: btnAction) {
                    Text("按钮2")
                }
                // 3. localized string, Available when Label is Text.
                Button(LocalizedStringKey("按钮3"), action: btnAction)
            }
            
            Divider()
            
            Text("Creating a button with a role")
            VStack{
                if #available(iOS 15.0, *) {
                    Button("按钮", role: .cancel, action:  btnAction)
                    Button(role: .destructive, action: btnAction) {
                        Text("按钮2")
                    }
                    Button(LocalizedStringKey("按钮3"), role: .none, action: btnAction)
                }
            }
            Divider()
            
            Text("Creating a button from a configuration")
//            VStack {
//
//                Button()
//            }
//            Divider()
            
            
            Text("Styling buttons")
            VStack{
                
                if #available(iOS 15.0, *) {
                    Button("样式-buttonBorderShape",action:  btnAction)
                        .frame(height: 30)
                        .padding(4)
                    
//                        .buttonStyle(BorderedProminentButtonStyle())
                        .buttonStyle(.bordered)
                    
                        // buttonStyle 为 .bordered 或 borderedProminent 样式。没有设置上述样式 将无效。
                        //.buttonBorderShape(ButtonBorderShape.roundedRectangle(radius: 15)) // 圆角矩形
                        //.buttonBorderShape(.roundedRectangle) // 圆角矩形
                        .buttonBorderShape(.capsule) // 胶囊
                }
                
                Button("样式-DefaultButtonStyle",action:  btnAction)
                    //.buttonStyle(DefaultButtonStyle())
                    .buttonStyle(.automatic)
                
                Button("样式-PlainButtonStyle",action:  btnAction)
                    //.buttonStyle(PlainButtonStyle())
                    .buttonStyle(.plain)
                
                Button("样式-BorderlessButtonStyle",action:  btnAction)
                    //.buttonStyle(BorderlessButtonStyle())
                    .buttonStyle(.borderless)
                
                if #available(iOS 15.0, *) {
                    Button("样式- .bordered",action:  btnAction)
                        .buttonStyle(.bordered)
                }
                
                Button("自定义样式-PrimitiveButtonStyle",action:  btnAction)
                .buttonStyle(RedBorderedButtonStyle())
            }
            Divider()
        }
    }
    
    func btnAction() {
        print("点击")
    }
}
