//
//  ContentView.swift
//  VStack
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            ForEach(
                1...10,
                id: \.self
            ) {
                Text("Item \($0)")
            }
        }
    }
}
