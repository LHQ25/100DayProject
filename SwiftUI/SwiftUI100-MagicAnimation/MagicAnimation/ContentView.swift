//
//  ContentView.swift
//  MagicAnimation
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var isSwitch:Bool = false
    
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack {
            ForEach(0..<8) { num in
                Image(systemName: isSwitch ? "heart.circle.fill" : "heart.circle")
                    .font(.system(size: 32))
                    .foregroundColor(isSwitch ? .red : .purple)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
            .onChanged({ value in
                dragAmount = value.translation
            })
            .onEnded({ _ in
                dragAmount = .zero
                isSwitch.toggle()
            })
        )
    }
}
