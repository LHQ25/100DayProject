//
//  ContentView.swift
//  6_SwiftUI(Gauge)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State private var batteryLevel = 0.4
    
    var body: some View {
        
        VStack {
            // MARK: - Creating a gauge
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") })
            
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") }, currentValueLabel: { Text("\(Int(batteryLevel * 10))") })
            
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") }, currentValueLabel: { Text("\(Int(batteryLevel * 10))") }, markedValueLabels: { Text("mark-\(Int(batteryLevel * 10))") })
            
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") }, currentValueLabel: { Text("\(Int(batteryLevel * 10))") }, minimumValueLabel: { Text("0") }, maximumValueLabel: { Text("10") })
            
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") }, currentValueLabel: { Text("\(Int(batteryLevel * 10))") }, minimumValueLabel: { Text("0") }, maximumValueLabel: { Text("10") }, markedValueLabels: { Text("min") })
            
            Gauge(value: batteryLevel, in: 0.0...1.0, label: { Text("Gauge") })
//                .gaugeStyle(.automatic)
                .gaugeStyle(.accessoryCircular)
//                .gaugeStyle(.accessoryCircularCapacity)
//                .gaugeStyle(.accessoryLinear)
//                .gaugeStyle(.accessoryLinearCapacity)
//                .gaugeStyle(.linearCapacity)
        }
        .padding()
    }
}

