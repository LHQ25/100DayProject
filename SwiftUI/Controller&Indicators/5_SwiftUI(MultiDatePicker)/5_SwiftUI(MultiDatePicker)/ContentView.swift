//
//  ContentView.swift
//  5_SwiftUI(MultiDatePicker)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var dates = Set<DateComponents>()
    
    private var start = Date(timeIntervalSinceNow: -(3600 * 24 * 100))
    private var end = Date(timeIntervalSinceNow: (3600 * 24 * 100))
    
    var body: some View {
        VStack {
            // MARK: - Picking dates
//            MultiDatePicker("MultiDatePicker", selection: $dates)
//            MultiDatePicker(selection: $dates, label: { Text("MultiDatePicker") })
            
            // MARK: - Picking dates in a range
//            MultiDatePicker("Picking dates in a range - end", selection: $dates, in: ..<end)
//            MultiDatePicker("Picking dates in a range - start", selection: $dates, in: start...)
//            MultiDatePicker(selection: $dates, in: ..<end, label: { Text("Picking dates in a range - end") })
            
            MultiDatePicker("Picking dates in a range - end", selection: $dates, in: start..<end)
        }
        .padding()
    }
}

