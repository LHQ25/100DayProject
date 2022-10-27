//
//  ContentView.swift
//  5_SwiftUI(ColorPicker)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var current = Color.red
    
    @State
    var current2: CGColor = UIColor.red.cgColor
    
    var body: some View {
        
        VStack {
            HStack(spacing: 8) {
                Text("当前1")
                    .frame(width: 100, height: 100)
                    .background(current)
                Text("当前2")
                    .frame(width: 100, height: 100)
                    .background(Color(cgColor: current2))
            }
            
            // MARK: - Creating a color picker
            ColorPicker(selection: $current, supportsOpacity: true, label: { Text("ColorPicker") })
            ColorPicker("ColorPicker", selection: $current, supportsOpacity: true)
            
            // MARK: - Creating a core graphics color picker
            ColorPicker(selection: $current2, supportsOpacity: true, label: { Text("ColorPicker") })
            ColorPicker("ColorPicker", selection: $current2, supportsOpacity: true)
        }
        .padding()
    }
}
