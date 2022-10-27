//
//  ContentView.swift
//  ZStack
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 50)
            Rectangle()
                .fill(Color.blue)
                .frame(width:50, height: 100)
        }
        .border(Color.green, width: 1)
    }
}

