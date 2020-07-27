//
//  ContentView.swift
//  Day13_3 SwiftUI(Toggle)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct RedBorderToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        Toggle(configuration).border(Color.red)
    }
}

struct ContentView: View {
    
    @State var isOn = false
    
    var body: some View {
        VStack{
            Text("Toggle")
            Divider()
            ///初始化
            VStack{
                Toggle(isOn: $isOn) { Text("Toggle_1") }
                Toggle("Toggle_2", isOn: $isOn)
                Toggle(LocalizedStringKey("Toggle_3"), isOn: $isOn)
            }
            Divider()
            ///样式
            VStack{
                Toggle(isOn: $isOn) { Text("Toggle_DefaultToggleStyle") }
                    .toggleStyle(DefaultToggleStyle())
                
                Toggle(isOn: $isOn) { Text("Toggle_SwitchToggleStyle") }
                    .toggleStyle(SwitchToggleStyle())
                
                Toggle(isOn: $isOn) { Text("Toggle_自定义样式") }
                    .toggleStyle(RedBorderToggleStyle())
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
