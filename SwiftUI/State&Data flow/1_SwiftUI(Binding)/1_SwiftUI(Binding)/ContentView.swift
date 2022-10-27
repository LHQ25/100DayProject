//
//  ContentView.swift
//  1_SwiftUI(Binding)
//
//  Created by 9527 on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    
    @State(initialValue: false)
    var isPlaying: Bool
    
    var body: some View {
        VStack {
            
            TempView(isPlaying: $isPlaying)
            Button("button") {
                isPlaying.toggle()
            }
            
        }
        .padding()
    }
}

struct TempView: View {

//    @Binding
//    var isPlaying: Bool
    
    @Binding
    var isPlaying: Bool
    
    @State
    private var playing: Bool = false
    
    var body: some View {
        Image(systemName: isPlaying ? "pause" : "play")
            .onTapGesture {
                isPlaying.toggle()
            }
    }
    func test() {
        
        // 从另一个绑定的值创建一个绑定。
        let tempBinding = Binding($playing)
        
        // 从另一个绑定的值创建一个绑定。
        let tempBinding2 = Binding(projectedValue: $playing)
        
        // 创建具有不可变值的绑定
        let tempBinding3 = Binding.constant(false)
        
        // MARK: - Getting the value
        let v = tempBinding3.wrappedValue
        let v2 = tempBinding3.projectedValue
        
        // MARK: - Applying animations
        
        $isPlaying
            .animation(.linear(duration: 2))
        
        // MARK: - Applying transactions
        $isPlaying.transaction(.init())
    }
}
