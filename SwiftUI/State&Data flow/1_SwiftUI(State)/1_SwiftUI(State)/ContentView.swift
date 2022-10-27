//
//  ContentView.swift
//  1_SwiftUI(State)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    
//    @State
//    private var isPlaying: Bool = false
    
//    @State(initialValue: false)
//    private var isPlaying: Bool
    
    @State(wrappedValue: false)
    private var isPlaying: Bool
    
    var body: some View {
        VStack {
            Image(systemName: isPlaying ? "pause" : "play")
                .font(Font.system(size: 30))
                .padding(.bottom, 20)
            Button {
                isPlaying.toggle()
            } label: {
                Text("button")
            }
        }
        .padding()
        .onAppear {
            
            // 状态变量引用的基础值。
            print($isPlaying.wrappedValue)
            // 绑定到状态值。
            print($isPlaying.projectedValue)
        }
    }
}

