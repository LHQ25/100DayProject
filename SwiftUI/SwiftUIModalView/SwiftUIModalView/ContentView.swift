//
//  ContentView.swift
//  SwiftUIModalView
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    
    @State var showDetailView = false

    
    var body: some View {
        //按钮
        Button(action: {
            // 点击按钮跳转打开模态弹窗
            self.showDetailView.toggle()
        }) {
            // 按钮样式
            Text("打开模态弹窗")
                .font(.system(size: 14))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                .cornerRadius(5)
                .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showDetailView) {      // 模态弹窗
            DetailView(showDetailView: $showDetailView)
        }
    }
}

