//
//  ContentView.swift
//  Day13_2 SwiftUI(NavigationLink)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    ///是否自动跳转子页面
    @State var isActive: Bool = false
    
    @State var popover: Bool = false
    
    @State var selection: Int?
    
    var body: some View {
        NavigationView{
            VStack{
                Text("NavigationLink")
                Divider()
                VStack{
                    
                    NavigationLink(destination: ContentView1(), isActive: $isActive) {
                        Text("创建——1")
                    }
                    NavigationLink(destination: ContentView1()) {
                        Text("创建——2")
                    }
                    NavigationLink(destination: ContentView1(), tag: 10, selection: $selection) {
                        Text("创建——3")
                    }
                    
                    NavigationLink(LocalizedStringKey("创建——4"), destination: ContentView1())
                    
                    NavigationLink("创建——5", destination: ContentView1())
                    
                    NavigationLink("创建——6", destination: ContentView1(), isActive: $isActive)
                    
                    NavigationLink(LocalizedStringKey("创建——7"), destination: ContentView1(), isActive: $isActive)
                    
                    NavigationLink(LocalizedStringKey("创建——8"), destination: ContentView1(), tag: 12, selection: $selection)
                    
                    NavigationLink("创建——9", destination: ContentView1(), tag: 13, selection: $selection)
                        .isDetailLink(false)
                }
            }
            
            .navigationBarTitle("首页", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
