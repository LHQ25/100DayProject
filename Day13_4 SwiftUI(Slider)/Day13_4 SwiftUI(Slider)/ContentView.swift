//
//  ContentView.swift
//  Day13_4 SwiftUI(Slider)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var value = 0.4
    
    var endValue = 0.0...0.9
    
    var body: some View {
        
        VStack{
            Text("Hello, World!")
            Divider()
            ///初始化
            VStack{
                Slider(value: $value)
                Slider(value: $value, in: endValue)
                Slider(value: $value, in: endValue) { (rest) in
                    print("是否滑动结束\(rest)")
                }
                Slider(value: $value, in: endValue, onEditingChanged: {
                    print("是否滑动结束\($0)")
                }) {
                    Text("Slider_4")
                }
                
                //step
                Slider(value: $value, in: endValue, step: 0.3) {
                    print("是否滑动结束\($0)")
                }
                
                Slider(value: $value, in: endValue, step: 0.2, onEditingChanged: {
                    print("是否滑动结束\($0)")
                }) {
                    Text("Slider_6")
                }
                
                //minimumValueLabel & maximumValueLabel
                Slider(value: $value, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("1.0")) {
                    Text("value")
                }
                
                Slider(value: $value, in: endValue, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("1.0")) {
                    Text("value")
                }
                
                Slider(value: $value, in: endValue, onEditingChanged: {
                    print("是否滑动结束\($0)")
                }, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("1.0")) {
                    Text("value")
                }
                
                Slider(value: $value, in: endValue, step: 0.1, onEditingChanged: {
                    print("是否滑动结束\($0)")
                }, minimumValueLabel: Text("0.0"), maximumValueLabel: Text("1.0")) {
                    Text("value")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
