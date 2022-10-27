//
//  ContentView.swift
//  4_SwiftUI(Slider)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var progress: Float = 0
    
    var body: some View {
        
        VStack {
            
            Text("\(progress)")
            
            // MARK: - Creating a slider
            
            // 创建一个滑块以从给定范围中选择一个值。
            // 当 Label 为 EmptyView 且 ValueLabel 为 EmptyView 时可用。
            Slider(value: $progress, in: 0...100) { (change) in
                
            }
            
            // 创建一个滑块以从给定范围中选择一个值，以步进增量为准。
            // 当 Label 为 EmptyView 且 ValueLabel 为 EmptyView 时可用。
            Slider(value: $progress, in: 0...100, step: 2) { (change) in
                
            }
            
            // MARK: - Creating a slider with labels
            // 创建一个滑块以从给定范围中选择一个值，该范围显示提供的标签。
            // Label 符合 View 且 ValueLabel 为 EmptyView 时可用。
            Slider(value: $progress, in: 0...100) {
                Text("1_\(progress)")
            } onEditingChanged: { (change) in
                
            }
            
            // 创建一个滑块以从给定范围中选择一个值，以步进增量为准，该滑块显示提供的标签。
            // Label 符合 View 且 ValueLabel 为 EmptyView 时可用。
            Slider(value: $progress, in: 0...100, step: 2) {
                Text("2_\(progress)")
            } onEditingChanged: { (change) in
                
            }
            
            // 创建一个滑块以从给定范围中选择一个值，该范围显示提供的标签。
            // Label 符合 View 且 ValueLabel 符合 View 时可用。
            Slider(value: $progress, in: 0...100) {
                Text("3_\(progress)")
            } minimumValueLabel: {
                Text("3_ml_\(progress)")
            } maximumValueLabel: {
                Text("3_ml_\(progress)")
            } onEditingChanged: { (change) in
                
            }

            // 创建一个滑块以从给定范围中选择一个值，以步长为单位，显示提供的标签。
            // Label 符合 View 且 ValueLabel 符合 View 时可用。
            Slider(value: $progress, in: 0...100, step: 2) {
                Text("4_\(progress)")
            } minimumValueLabel: {
                Text("4_ml_\(Int(progress))")
            } maximumValueLabel: {
                Text("4_ml_\(Int(progress))")
            } onEditingChanged: { (change) in
                
            }
        }
        .padding()
    }
}
