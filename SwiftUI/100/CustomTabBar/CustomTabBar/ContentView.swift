//
//  ContentView.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var showSidebar: Bool = false
    
    var body: some View {
        
        
        SidebarStack(sidebarWidth: 200, showSidebar: $showSidebar) {
            Color.red
        } content: {
            RootView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
