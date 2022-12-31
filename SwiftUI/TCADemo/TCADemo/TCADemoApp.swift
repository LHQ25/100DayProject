//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by 9527 on 2022/11/15.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
              store: Store(
                initialState: Counter(),
                reducer: counterReducer,
                environment: CounterEnvironment())
            )
        }
    }
}
