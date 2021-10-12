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
//        Button(PrimitiveButtonStyleConfiguration)
        return Button(configuration).border(Color.red)
    }
}


struct ContentView: View {
    
    var body: some View {
        ///初始化
        VStack{
            ///初始化
            VStack{
                //创建一个从字符串生成其标签的按钮
                Button("初始化",action:  btnAction)
                //2
//                Button(action: btnAction) {
//                    Text("按钮2")
//                }
//                //3
//                Button(LocalizedStringKey("按钮3"), action: btnAction)
//                //4
//                Button(action: btnAction) {
//                    Text("按钮4")
//                }.buttonStyle(RedBorderedButtonStyle())
            }
            Divider()
            ///样式
            VStack{
                Button("样式-DefaultButtonStyle",action:  btnAction)
                    .buttonStyle(DefaultButtonStyle())
                
                Button("样式-PlainButtonStyle",action:  btnAction)
                    .buttonStyle(PlainButtonStyle())
                
                Button("样式-BorderlessButtonStyle",action:  btnAction)
                    .buttonStyle(BorderlessButtonStyle())
                
                Button("自定义样式-RedBorderedButtonStyle",action:  btnAction)
                .buttonStyle(RedBorderedButtonStyle())
                
                
            }
            Divider()
            ///其它 Button
            VStack{
                EditButton().frame(width: 100, height: 30)
            }
        }
    }
    
    func btnAction() {
        print("点击")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
