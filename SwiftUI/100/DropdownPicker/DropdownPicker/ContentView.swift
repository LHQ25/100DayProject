//
//  ContentView.swift
//  DropdownPicker
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var selection: Int = 0
    
    var body: some View {
        
        DropdownPicker(title: "Size", selection: $selection, options: ["Small", "Medium", "Large", "X-Large"])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
