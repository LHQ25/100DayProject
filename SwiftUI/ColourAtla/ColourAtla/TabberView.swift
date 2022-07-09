//
//  TabberView.swift
//  ColourAtla
//
//  Created by 9527 on 2022/7/9.
//

import SwiftUI

struct TabberView: View {
    @State private var selectTab = 0
    
    var body: some View {
        
        TabView(selection: $selectTab) {
            ContentView ()
                .tabItem {
                    if self.selectTab == 0 {
                        Image(systemName: "house")
                    } else {
                        Image(systemName: "house.fill")
                    }
                    Text("首页")
                }.tag(0)
            
            MineView()
                .tabItem {
                    if self.selectTab == 1 {
                        Image(systemName: "person")
                    } else {
                        Image(systemName: "person.fill")
                    }
                    Text("我的")
                }.tag(1)
        }
        .accentColor(Color.Hex(0x409EFF))
    }
}
