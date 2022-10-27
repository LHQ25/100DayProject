//
//  ContentView.swift
//  5_SwiftUI(DatePicker)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var date: Date = Date()
    
    var body: some View {
        VStack {
            
            // MARK: - Creating a date picker for any date
            DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute], label: { Text("DatePicker") })
            DatePicker("DatePicker2", selection: $date, displayedComponents: [.date, .hourAndMinute])
            
            // MARK: - Creating a date picker for a range
            DatePicker(selection: $date, in: date.addingTimeInterval(-20000)...date.addingTimeInterval(20000), displayedComponents: [.date, .hourAndMinute], label: { Text("DatePicker") })
            DatePicker("DatePicker2", selection: $date, in: date.addingTimeInterval(-20000)...date.addingTimeInterval(20000), displayedComponents: [.date, .hourAndMinute])
            
            // MARK: - Creating a date picker with an start date
            DatePicker(selection: $date, in: date.addingTimeInterval(-20000)..., displayedComponents: [.date, .hourAndMinute], label: { Text("DatePicker") })
            DatePicker("DatePicker2", selection: $date, in: date.addingTimeInterval(-20000)..., displayedComponents: [.date, .hourAndMinute])
            
            // MARK: - Creating a date picker with an end date
            DatePicker(selection: $date, in: ...date.addingTimeInterval(20000), displayedComponents: [.date, .hourAndMinute], label: { Text("DatePicker") })
            DatePicker("DatePicker2", selection: $date, in: ...date.addingTimeInterval(20000), displayedComponents: [.date, .hourAndMinute])
            
            // MARK: - Styling date pickers
            DatePicker("DatePicker2", selection: $date, displayedComponents: [.date, .hourAndMinute])
//                .datePickerStyle(.automatic)
//                .datePickerStyle(.wheel)
//                .datePickerStyle(.compact)
                .datePickerStyle(.graphical)
        }
        .padding()
    }
}
