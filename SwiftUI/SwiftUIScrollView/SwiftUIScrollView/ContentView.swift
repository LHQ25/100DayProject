//
//  ContentView.swift
//  SwiftUIScrollView
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(1...10, id: \.self) {
                    return itemView(name: "\($0)")
                }
            }
        }

    }
    
    func itemView(name: String) -> some View {
        VStack(alignment: .leading) {
            Image("10")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("你的能力是否能在全世界通用，如果不能，那么需求重新评估你的能力。")
                .font(.system(size: 17))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10) .stroke(Color(red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1))
        .padding([.top, .horizontal])
    }
}
