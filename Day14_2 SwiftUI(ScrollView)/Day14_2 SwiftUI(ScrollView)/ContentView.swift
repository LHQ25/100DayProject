//
//  ContentView.swift
//  Day14_2 SwiftUI(ScrollView)
//
//  Created by 亿存 on 2020/7/28.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: true) {
            Text("Hello, World! 1").frame(width: UIScreen.main.bounds.size.width, height: 90)
            Text("Hello, World! 2").frame(height: 90)
            Text("Hello, World! 3").frame(height: 90)
            Text("Hello, World! 4").frame(height: 90)
            Text("Hello, World! 5").frame(height: 90)
            Text("Hello, World! 6").frame(height: 90)
            Text("Hello, World! 7").frame(height: 90)
            Text("Hello, World! 8").frame(height: 90)
            Text("Hello, World! 9").frame(height: 90)
            Text("Hello, World! 10").frame(height: 90)
        }
        
        //属性
        // content
        // axes
        // showsIndicators
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
