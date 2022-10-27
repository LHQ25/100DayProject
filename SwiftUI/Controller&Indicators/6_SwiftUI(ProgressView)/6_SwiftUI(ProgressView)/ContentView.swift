//
//  ContentView.swift
//  6_SwiftUI(ProgressView)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var pro: CGFloat = 3
    
    private var start = Date(timeIntervalSinceNow: -(3600 * 24 * 100))
    private var end = Date(timeIntervalSinceNow: (3600 * 24 * 100))
    
    var body: some View {
        VStack {
            
            // MARK: - Creating an indeterminate progress view
            ProgressView()
            
            ProgressView(label: { Text("ProgressView") })
            
            ProgressView("ProgressView")
            
            // MARK: - Creating a determinate progress view
            ProgressView(Progress(totalUnitCount: 10))

            ProgressView(value: pro, total: 10)

            ProgressView("ProgressView", value: pro, total: 10)

            ProgressView(value: pro, total: 10, label: { Text("ProgressView").foregroundColor(.cyan) })

            ProgressView(value: pro, total: 10, label: { Text("ProgressView").foregroundColor(.cyan) }, currentValueLabel: { Text("currentValueLabel").foregroundColor(.cyan) })
            
            // MARK: - Create a progress view spanning a date range
            // ProgressView(timerInterval: start...end, countsDown: true)
            // ProgressView(timerInterval: start...end, countsDown: true, label: { Text("timerInterval") })
            // ProgressView(timerInterval: start...end, countsDown: true, label: { Text("timerInterval") }, currentValueLabel: { Text("currentValueLabel").foregroundColor(.cyan) })
            
            // MARK: - Creating a configured progress view
            ProgressView(value: pro, total: 10)
                .progressViewStyle(DarkBlueShadowProgressViewStyle())
            
            // MARK: - Styling progress views
            ProgressView(value: pro, total: 10)
//                .progressViewStyle(.automatic)
//                .progressViewStyle(.circular)
                .progressViewStyle(.linear)
        }
        .padding()
    }
}

struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}
