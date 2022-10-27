//
//  ContentView.swift
//  LazyVStack
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            
            // pinnedViews: 固定视图 headerView 和 footerView
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders, .sectionFooters]) {
                Section(header: Text("header")) {
                    ForEach(1...100, id: \.self) {
                        Text("Row \($0)")
                    }
                }
            }
        }
        
    }
}


