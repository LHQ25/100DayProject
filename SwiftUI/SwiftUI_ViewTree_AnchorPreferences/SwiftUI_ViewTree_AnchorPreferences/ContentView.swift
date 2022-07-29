//
//  ContentView.swift
//  SwiftUI_ViewTree_AnchorPreferences
//
//  Created by 9527 on 2022/7/29.
//
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        EasyExample()
    }
}

struct EasyExample : View {

    @State private var activeIdx: Int = 0

    var body: some View {

        VStack {
            Spacer()

            HStack {
                MonthView(activeMonth: $activeIdx, label: "January", idx: 0)
                MonthView(activeMonth: $activeIdx, label: "February", idx: 1)
                MonthView(activeMonth: $activeIdx, label: "March", idx: 2)
                MonthView(activeMonth: $activeIdx, label: "April", idx: 3)
            }

            Spacer()

            HStack {
                MonthView(activeMonth: $activeIdx, label: "May", idx: 4)
                MonthView(activeMonth: $activeIdx, label: "June", idx: 5)
                MonthView(activeMonth: $activeIdx, label: "July", idx: 6)
                MonthView(activeMonth: $activeIdx, label: "August", idx: 7)
            }

            Spacer()

            HStack {
                MonthView(activeMonth: $activeIdx, label: "September", idx: 8)
                MonthView(activeMonth: $activeIdx, label: "October", idx: 9)
                MonthView(activeMonth: $activeIdx, label: "November", idx: 10)
                MonthView(activeMonth: $activeIdx, label: "December", idx: 11)
            }

            Spacer()
        }
                // .backgroundPreferenceValue() 相对应的是.overlayPreferenceValue()，
                // 它们的作用相同，只不过一个是绘制背景，一个是绘制前景
                .backgroundPreferenceValue(MyTextPreferenceKey.self) { value in
                    // 可以不用关心空间坐标，也让Anchor的值变的有用
                    GeometryReader { proxy in
                        ZStack {
                            createBorder(proxy, value)
                        }.frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
    }

    func createBorder(_ geometry: GeometryProxy, _ preferences: [MyTextPreferenceData]) -> some View {

        let p = preferences.first(where: { $0.viewIdx == activeIdx })
        let bounds = p != nil ? geometry[p!.bounds] : .zero
        return RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 3.0)
                .foregroundColor(Color.green)
                .frame(width: bounds.size.width, height: bounds.size.height)
                .fixedSize()
                .offset(x: bounds.minX, y: bounds.minY)
                .animation(.easeInOut(duration: 1.0))
    }
}