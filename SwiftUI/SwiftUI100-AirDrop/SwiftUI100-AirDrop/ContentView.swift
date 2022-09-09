//
//  ContentView.swift
//  SwiftUI100-AirDrop
//
//  Created by 9527 on 2022/9/8.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationCircle = false
    
    var body: some View {
        
        ZStack {
            
            Image(systemName: "antenna.radiowaves.left.and.right.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            Circle()
                .stroke()
                .frame(width: 340, height: 340)
                .foregroundColor(.blue)
                .scaleEffect(animationCircle ? 1 : 0.3)
                .opacity(animationCircle ? 0 : 1)
            
            Circle()
                .stroke()
                .frame(width: 240, height: 240)
                .foregroundColor(.blue)
                .scaleEffect(animationCircle ? 1 : 0.3)
                .opacity(animationCircle ? 0 : 1)
            
            Circle()
                .stroke()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .scaleEffect(animationCircle ? 1 : 0.3)
                .opacity(animationCircle ? 0 : 1)
        }
        .onAppear {
            
            withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
                animationCircle.toggle()
            }
        }
    }
}
