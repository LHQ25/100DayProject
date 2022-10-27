//
//  ContentView.swift
//  4_SwiftUI(Stepper)
//
//  Created by 9527 on 2022/9/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var value: Float = 0
    
    var body: some View {
        VStack {
    
            Text("\(Int(value))")
            
            // MARK: - Creating a stepper
            // 创建一个步进器，该步进器配置为使用您提供的步长值增加或减少与值的绑定。
            // Label 符合 View 时可用。
            Stepper(value: $value, step: 3, label: { Text("Stepper1") }, onEditingChanged: { _ in })
            
            // 创建一个步进器，该步进器配置为使用您提供的步进值增加或减少与值的绑定，并以应用的格式样式显示其值。
            // Label 符合 View 时可用。
            Stepper(value: $value, in: FloatingPointFormatStyle<Float>.FormatInput(1.0)...FloatingPointFormatStyle<Float>.FormatInput(100.0),
                    format: .number, label: { Text("Stepper2")  }, onEditingChanged: { _ in  })
            
            // 创建一个带有标题键的步进器，并配置为增加和减少与您提供的值和步长的绑定。
            // 当标签为文本时可用。
            Stepper("Stepper3", value: $value, step: 4, onEditingChanged: { _ in })
            
            // 创建一个带标题的步进器，并配置为增加和减少与您提供的值和步长的绑定，并使用应用的格式样式显示其值。
            // 当标签为文本时可用。
            Stepper("Stepper4", value: $value, step: 5, format: .number, onEditingChanged: { _ in })
            
            Divider()
            // MARK: - Creating a stepper over a range
            // 创建一个步进器，该步进器配置为使用步进值在您提供的值范围内增加或减少与值的绑定。
            // Label 符合 View 时可用。
            Stepper(value: $value, in: 0...100, step: 2.0, label: { Label("123", image: "sun") }, onEditingChanged: { _ in})
            // 创建一个步进器，该步进器配置为使用步进值在您提供的值范围内递增或递减与值的绑定，并以应用的格式样式显示其值。
            // Label 符合 View 时可用。
            Stepper(value: $value, in: FloatingPointFormatStyle<Float>.FormatInput(0)...FloatingPointFormatStyle<Float>.FormatInput(100),
                    step: 2.0, format: .number, label: { Label("1231", image: "sun") }, onEditingChanged: { _ in })
            // 创建一个步进器实例，该实例按步长在您提供的封闭范围内递增和递减与值的绑定。
            // 当标签为文本时可用。
            Stepper("range", value: $value, in: 0...100, step: 2.0, onEditingChanged: { _ in})
            
//            Stepper("range2", value: $value, in: FloatingPointFormatStyle<Float>.FormatInput(0)...FloatingPointFormatStyle<Float>.FormatInput(100),
//                    step: 2.0, format: .number, onEditingChanged: { _ in })
            
            Divider()
            // MARK: - Creating a stepper with change behavior
//            Stepper(label: { Label("behavior", image: "") }, onIncrement: { value += 1 }, onDecrement: { value -= 1 }, onEditingChanged: { _ in })
            
            // 创建一个使用标题键的步进器，并在用户单击或点击步进器的递增和递减按钮时执行您提供的闭包。
            // 当标签为文本时可用。
//            Stepper("behavior2", onIncrement: { value += 1 }, onDecrement: { value -= 1 }, onEditingChanged: { _ in })
        }
        .padding()
    }
}
