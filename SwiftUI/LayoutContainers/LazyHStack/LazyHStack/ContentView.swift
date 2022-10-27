//
//  ContentView.swift
//  LazyHStack
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        // 一种视图，它将其子排列在水平增长的一行中，只在需要时创建项
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 10, pinnedViews: .sectionHeaders) {
                ForEach(1...100, id: \.self) {
                    Text("Column \($0)")
                }
            }
        }
    }
}
