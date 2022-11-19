//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by 9527 on 2022/11/15.
//

import SwiftUI

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(initialState: Counter(), reducer: counterReducer, environment: CounterEnvironment())
            )
        }
    }
}
