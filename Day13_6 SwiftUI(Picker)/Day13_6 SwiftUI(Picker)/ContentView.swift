//
//  ContentView.swift
//  Day13_6 SwiftUI(Picker)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate
    case vanilla
    case strawberry

    var id: String { self.rawValue }
}

enum Topping: String, CaseIterable, Identifiable {
    case nuts
    case cookies
    case blueberries

    var id: String { self.rawValue }
}
extension Flavor {
    var suggestedTopping: Topping {
        switch self {
        case .chocolate: return .nuts
        case .vanilla: return .cookies
        case .strawberry: return .blueberries
        }
    }
}

struct ContentView: View {
    
    @State private var selectedFlavor = Flavor.vanilla
    
    private let titles = ["value_1","value_2","value_3","value_4"]
    @State private var selectedValue = "value_1"
    
    
    
    var body: some View {
        VStack{
            Text("Picker")
            Divider()
            ///初始化
//            VStack{
//                Picker("Picker_1", selection: $selectedFlavor) {
//                    ForEach(Flavor.allCases) { flavor in
//                        Text(flavor.rawValue.capitalized).tag(flavor.suggestedTopping)
//                    }
//                }
//
//                Picker(LocalizedStringKey("Picker_2"), selection: $selectedValue){
//                    ForEach(0..<titles.count) {
//                        Text(self.titles[$0])
//                    }
//                }
//
//                Picker(selection: $selectedValue, label: Text("Picker_3")) {
//                    ForEach(0..<titles.count) {
//                        Text(self.titles[$0])
//                    }
//                }
//            }
            Divider()
            //样式
            VStack{
                Picker("Picker_4", selection: $selectedFlavor) {
                    ForEach(Flavor.allCases) { flavor in
                        Text(flavor.rawValue.capitalized).tag(flavor.suggestedTopping)
                    }
                }.pickerStyle(DefaultPickerStyle())
                
                Picker(LocalizedStringKey("Picker_5"), selection: $selectedValue){
                    ForEach(0..<titles.count) {
                        Text(self.titles[$0])
                    }
                    }.pickerStyle(SegmentedPickerStyle())
                
                Picker(selection: $selectedValue, label: Text("Picker_6")) {
                    ForEach(0..<titles.count) {
                        Text(self.titles[$0])
                    }
                }.pickerStyle(WheelPickerStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
