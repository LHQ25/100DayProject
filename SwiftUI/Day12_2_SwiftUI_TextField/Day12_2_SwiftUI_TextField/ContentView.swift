//
//  ContentView.swift
//  Day12_2_SwiftUI_TextField
//
//  Created by 亿存 on 2020/7/22.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var bindString: String = ""
    @State var bindString2: String = ""
    @State var bindString3: String = ""
    @State var bindString4: String = ""
    
    ///使用子类
    var formatter1 = DateFormatter()
    
    var body: some View {
        VStack{
            //创建
            VStack{
                
                TextField("标题字符串生成带有文本标签的文本字段", text: $bindString, onEditingChanged: { (res) in
                    print(res,"onEditingChanged")
                }) {
                    print("TextField commit")
                }
                .frame(height: 30)
                .padding()
                
                TextField(LocalizedStringKey("带有从本地化标题字符串生成的文本标签的文本字段"), text: $bindString2, onEditingChanged: { (res) in
                    print(res,"onEditingChanged2")
                }) {
                    print("TextField commit2")
                }
                .frame(width: 200, height: 30)
                
                TextField("绑定任意类型的实例", value: $bindString3, formatter: formatter1, onEditingChanged: { (res) in
                    print(res,"onEditingChanged3")
                }) {
                    print("TextField commit3")
                }.frame(width: 200, height: 30)
                
                TextField(LocalizedStringKey("创建一个绑定任意类型T的实例"), value: $bindString4, formatter: formatter1, onEditingChanged: { (res) in
                    print(res,"onEditingChanged4")
                }) {
                    print("TextField commit4")
                }
            }
            
            Divider()
            //MARK: - 样式
            VStack{
                
                
                TextField("没有装饰的文本字段样式", text: $bindString, onEditingChanged: { (res) in
                    print(res,"onEditingChanged")
                }) {
                    print("TextField commit")
                }.textFieldStyle(PlainTextFieldStyle())
                .frame(width: 200, height: 30)
                
                TextField("圆角边框的文本字段样式", text: $bindString, onEditingChanged: { (res) in
                    print(res,"onEditingChanged")
                }) {
                    print("TextField commit")
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200, height: 30)
                
                TextField("正方形边框的文本字段样式", text: $bindString, onEditingChanged: { (res) in
                    print(res,"onEditingChanged")
                }) {
                    print("TextField commit")
                }.textFieldStyle(DefaultTextFieldStyle())
                    .frame(width: 200, height: 30)
                    .textContentType(.emailAddress) //文本类型
            
            }
            Divider()
            
            //SecureField  密码框
            VStack{
                SecureField("密码框1", text: $bindString2) {
                    
                    }.frame(width: 300, height: 30).textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField(LocalizedStringKey("密码框2"), text: $bindString2) {
                    
                }.frame(width: 300, height: 30).textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
        }
    }
}
