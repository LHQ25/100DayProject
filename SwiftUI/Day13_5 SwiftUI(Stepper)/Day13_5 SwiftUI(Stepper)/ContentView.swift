//
//  ContentView.swift
//  Day13_5 SwiftUI(Stepper)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var value = 0
    
    let closeRange = 0...10
    let step = 2
    
    var body: some View {
        VStack{
            Text("Stepper")
            Divider()
            ///初始化
            VStack{
                Stepper("Stepper_1", onIncrement: inCrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged(isEnd:))
                
                Stepper(LocalizedStringKey("Stepper_2"), onIncrement: inCrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged(isEnd:))
                
                Stepper("Stepper_3", value: $value, in: closeRange, step: step, onEditingChanged: onEditingChanged(isEnd:))
                
                Stepper(LocalizedStringKey("Stepper_4"), value: $value, in: closeRange, step: step, onEditingChanged: onEditingChanged(isEnd:))
                
                Stepper("Stepper_5", value: $value,step: step, onEditingChanged: onEditingChanged(isEnd:))
                
                
                Stepper(onIncrement: inCrement, onDecrement: onDecrement) {
                    Text("Stepper_6")
                }
                
                Stepper(value: $value, in: closeRange, step: step, onEditingChanged: onEditingChanged(isEnd:)) {
                    Text("Stepper_7")
                }
                
                Stepper(value: $value, step: step, onEditingChanged: onEditingChanged(isEnd:)){
                    Text("Stepper_8")
                }
            }
        }
    }
    
    func inCrement() {
        print("inCrement")
    }
    
    func onDecrement() {
        print("onDecrement")
    }
    
    func onEditingChanged(isEnd: Bool) {
        print("onEditingChanged -- \(isEnd)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
