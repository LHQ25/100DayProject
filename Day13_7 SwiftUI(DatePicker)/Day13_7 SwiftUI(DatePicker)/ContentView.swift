//
//  ContentView.swift
//  Day13_7 SwiftUI(DatePicker)
//
//  Created by 亿存 on 2020/7/27.
//  Copyright © 2020 亿存. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var date: Date = Date()
    
    let partialRangeThrough = Date(timeIntervalSince1970: 1532670074)...Date(timeIntervalSince1970: 1595828474)
    let partialRangeThrough2 = ...Date(timeIntervalSince1970: 1595828474)
    
    let partialRangeThrough_from = Date(timeIntervalSince1970: 1595828474)...
    
    let closeRange = Date(timeIntervalSince1970: 1532670074)...Date(timeIntervalSince1970: 1595828474)
    
    var body: some View {
        VStack{
            
            Text("Picker")
            Divider()
            
            VStack {
                //1
//                DatePicker(LocalizedStringKey("DatePicker_1"), selection: $date, displayedComponents: .date)
                //2
//                DatePicker("DatePicker_2", selection: $date, displayedComponents: .hourAndMinute)
                
                //3
                /// You create `PartialRangeThrough` instances by using the prefix closed range
                /// operator (prefix `...`)
                //PartialRangeThrough<Date>
//                DatePicker("DatePicker_3",selection: $date,in: partialRangeThrough2, displayedComponents: .date)
                
                //4
                //CloseRange<Date>
//                DatePicker("DatePicker_4",selection: $date, in: closeRange, displayedComponents: .date)
                
                //5
//                DatePicker(LocalizedStringKey("DatePicker_5"), selection: $date, in: partialRangeThrough2, displayedComponents: .date)
                //6
//                DatePicker(LocalizedStringKey("DatePicker_6"), selection: $date, in: closeRange, displayedComponents: .date)
                //7
//                DatePicker(LocalizedStringKey("DatePicker_7"), selection: $date, in: partialRangeThrough_from, displayedComponents: .date)
                
                //8
//                DatePicker(LocalizedStringKey("DatePicker_8"), selection: $date, in: partialRangeThrough_from, displayedComponents: .date)
                
                //9
//                DatePicker(selection: $date, displayedComponents: .date) {
//                    Text("DatePicker_9")
//                }
                
                //10
//                DatePicker(selection: $date, in: partialRangeThrough_from, displayedComponents: .date){
//                    Text("DatePicker_10")
//                }
                
                //11
//                DatePicker(selection: $date, in: PartialRangeThrough, displayedComponents: .date){
//                    Text("DatePicker_11")
//                }

                //12
                DatePicker(selection: $date, in: closeRange, displayedComponents: .date){
                    Text("DatePicker_12")
                }
                
            }
            
            VStack{
//                DatePicker(LocalizedStringKey("style_DefaultDatePickerStyle"), selection: $date, displayedComponents: .date)
//                    .datePickerStyle(DefaultDatePickerStyle())
                
                DatePicker(LocalizedStringKey("style_DefaultDatePickerStyle"), selection: $date, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
