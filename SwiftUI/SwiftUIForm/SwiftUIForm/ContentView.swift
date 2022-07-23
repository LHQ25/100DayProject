//
//  ContentView.swift
//  SwiftUIForm
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    Text("关于本机")
                    NavigationLink {
                        UpdateView(title: "系统更新")
                    } label: {
                        Text("系统更新")
                    }
                }
                Section {
                    NavigationLink {
                        DetailView(title: "隔空投送")
                    } label: {
                        Text("隔空投送")
                    }
                    Text("隔开播放与接力")
                    Text("画中画")
                }
                Section {
                    Text("iPhone存储空间")
                    Text("后台app刷新")
                }
                Section {
                    Text("日期与时间")
                    Text("键盘")
                    Text("字体")
                    Text("语言与地区")
                    Text("词典")
                }
            }
            .navigationTitle("Form")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

