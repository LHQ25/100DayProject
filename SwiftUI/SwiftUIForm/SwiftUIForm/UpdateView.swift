//
//  UpdateView.swift
//  SwiftUIForm
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct UpdateView: View {
    
    var title: String
    
    @State private var isAbout: Bool = false
    
    var body: some View {
        Form {
            Section(content: {
                Toggle("关于本机", isOn: $isAbout)
                Toggle("系统更新", isOn: $isAbout)
            }, footer: {
                Text("下载后在夜间自动安装软件更新。更新安装前您会收到通知。iPhone 必须为充电状态并接入 Wi-Fi以完成更新。")
            })
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
