//
//  ContentView.swift
//  LazyHGrid
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    
    // 固定大小
    let rows = [GridItem(.fixed(30)), GridItem(.fixed(40))]
    // 单个item 自适应的大小
    let rows2 = [GridItem(.flexible(minimum: 30, maximum: 40), spacing: 8), GridItem(.flexible(minimum: 30, maximum: 40))]
    
    // 多个item 自适应的大小，尽可能的插入到视图上
    let rows3 = [GridItem(.adaptive(minimum: 30)), GridItem(.adaptive(minimum: 30, maximum: 40))]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows3) {
                ForEach(0x1f600...0x1f679, id: \.self) { value in
                    Text(String(format: "%x", value))
                        .background(.red)
                    Text(emoji(value))
                        .font(.largeTitle)
                        .background(.green)
                }
            }
        }
    }
    
    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}
