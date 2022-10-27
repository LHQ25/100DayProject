//
//  ContentView.swift
//  4_SwiftUI(Toggle)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOn = true
    @State var alarm = [Alarm(isOn: true, name: "Morning"),
                        Alarm(isOn: true, name: "afternoon")
    ]
    
    var body: some View {
        VStack {
            Text("\(isOn ? "on" : "off")")
            
            // MARK: - Creating a toggle
            Toggle(isOn: $isOn, label: { Text("Creating") })
            Toggle("Creating", isOn: $isOn)
            
            // MARK: - Creating a toggle for a collection
            Toggle(sources: $alarm, isOn: \.isOn, label: { Text("Enable all alarms") })
            Toggle("Enable all alarms", sources: $alarm, isOn: \.isOn)
            
            // MARK: - Creating a toggle from a configuration
            Toggle("Styling", isOn: $isOn)
                .toggleStyle(ChecklistToggleStyle())
            
            // MARK: - Styling a toggle
            Toggle("Styling", isOn: $isOn)
//                .toggleStyle(.automatic)
                .toggleStyle(.button)
//                .toggleStyle(.switch)
        }
        .padding()
    }
}

struct ChecklistToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack{
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                configuration.label
            }
        }
        .tint(.primary)
        .buttonStyle(.borderless)
    }
}

struct Alarm: Hashable, Identifiable {
  var id = UUID()
  var isOn = false
  var name = ""
}
