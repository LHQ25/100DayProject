//
//  ContentView.swift
//  SwiftUI100-StyleSheet
//
//  Created by 9527 on 2022/9/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("一枝梨花压海棠")
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding()
                .modifier(MainTitle())
            
            Text("一枝梨花压海棠")
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding()
                .mainTitle()
        }
    }
}

struct MainTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
    }
}

// 更加优雅点，想要像修饰符一样调用ViewModifier视图修饰器，也可以做一些拓展
extension View {
    
    func mainTitle() -> some View {
        self.modifier(MainTitle())
    }
}
