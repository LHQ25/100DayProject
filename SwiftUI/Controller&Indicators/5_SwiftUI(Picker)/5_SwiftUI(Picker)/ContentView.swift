//
//  ContentView.swift
//  5_SwiftUI(Picker)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var value: String = "sel_2"
    @State var sources = [PickerItem(name: "1", age: 1), PickerItem(name: "1", age: 1), PickerItem(name: "1", age: 1)]
    @State private var sel_Item = PickerItem(name: "sel", age: 0)
    
    var body: some View {
        VStack {
            Text(value)
            // MARK: - Creating a picker
            Picker(selection: $value, content: {
                Text("sel_1")
                Text("sel_2")
                Text("sel_3")
            }, label: { Text("Picker") })
            
            Picker("Picker2", selection: $value, content: {
                Text("sel_1")
                Text("sel_2")
                Text("sel_3")
            })
            
            // MARK: - Creating a picker for a collection
            Picker("collection", sources: $sources, selection: \.name, content: {
                ForEach(sources, id: \.id) { source in
                    Text(source.name)
                }
            })
            
            Picker(sources: $sources, selection: \.name, content: {
                ForEach(sources, id: \.id) { source in
                    Text(source.name)
                }
            }, label: { Text("collection") })
            
            // MARK: - Styling pickers
            Picker("Picker2", selection: $value, content: {
                Text("sel_1")
                Text("sel_2")
                Text("sel_3")
            })
//            .pickerStyle(.automatic)
            .pickerStyle(.inline)
            
//            .pickerStyle(.menu)
//            .menuOrder(.priority)
            
//            .pickerStyle(.segmented)
//            .pickerStyle(.wheel)
            
        }
        .padding()
    }
}

struct PickerItem: Identifiable {
    var id = UUID()
    var name: String
    var age: Int
}
