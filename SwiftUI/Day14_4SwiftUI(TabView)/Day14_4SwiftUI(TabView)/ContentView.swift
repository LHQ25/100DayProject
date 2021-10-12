//
//  ContentView.swift
//  Day14_4SwiftUI(TabView)
//
//  Created by 亿存 on 2020/7/28.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @State var selection = 1
    
    var body: some View {
//        TabView {
//            Text("First Tab")
//                .tabItem {
//                    Image(systemName: "1.square.fill")
//                    Text("First")
//            }
//            Text("Second Tab")
//                .tabItem {
//                    Image(systemName: "2.square.fill")
//                    Text("Second")
//            }
//            Text("Three Tab")
//                .tabItem {
//                    Image(systemName: "3.square.fill")
//                    Text("Three")
//            }
//            Text("Four Tab")
//                .tabItem {
//                    Image(systemName: "4.square.fill")
//                    Text("Four")
//            }
//        }.font(.headline)
        
        //该实例从与Selection值关联的内容中进行选择
        TabView(selection: $selection) {
            Text("First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
            }.tag(0)
            Text("Second Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
            }.tag(1)
            Text("Three Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Three")
            }.tag(2)
            Text("Four Tab")
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("Four")
            }.tag(3)
        }.font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
