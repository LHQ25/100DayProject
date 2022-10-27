//
//  ContentView.swift
//  HStack
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 10
        ) {
            ForEach(
                1...5,
                id: \.self
            ) {
                Text("Item \($0)")
            }
        }
    }
}
