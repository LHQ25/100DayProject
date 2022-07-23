//
//  ContentView.swift
//  SwiftUINavigationView
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    
    // 定义数组，存放数据
    var messages = [Message(name: "这是微信", image: "weixin"),
                    Message(name: "这是微博", image: "weibo"),
                    Message(name: "这是QQ", image: "qq"),
                    Message(name: "这是电话", image: "phone"),
                    Message(name: "这是邮箱", image: "mail")
    ]

    
    var body: some View {
        NavigationView {
            List(messages/*, id: \.id*/) { model in
                
                NavigationLink(destination: DetailView(message: model)) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                        Text(model.name)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(Text("list"))
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

// 遵守 Identifiable 协议， id 可以不用写了
struct Message: Identifiable {
    
    var id = UUID()

    var name: String
    var image: String
}
