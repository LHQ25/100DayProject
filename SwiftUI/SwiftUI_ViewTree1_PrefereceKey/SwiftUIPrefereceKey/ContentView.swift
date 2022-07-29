//
//  ContentView.swift
//  SwiftUIPrefereceKey
//
//  Created by 9527 on 2022/7/29.
//
//

import SwiftUI

// 数据模型
struct MyTextPreferenceData: Equatable {

    let viewIdx: Int
    let rect: CGRect
}

struct MyTextPreferenceKey: PreferenceKey {
    // value 我们想要通过PreferenceKey获得什么类型的一个别名，例子中我们用的是[MyTextPreferenceData]数组
    typealias Value = [MyTextPreferenceData]

    // 没有显式设置首选项时，SwiftUI会用这个默认值。
    static var defaultValue: [MyTextPreferenceData] = []

    // 用来覆盖在视图树中找到的所有键值对，是一个静态函数。
    // 通常你可以用来累加接收到的所有值。
    // 在我们的例子中，当SwiftUI遍历视图树时，会把所有preference键值对存储在一个数组中。值是按照视图树的顺序给reduce函数的
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct ContentView: View {
    var body: some View {

        // normal
        // EasyExample()

        //
        EasyExample2()
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
    }
}

struct EasyExample2 : View {

    @State private var activeIdx: Int = 0
    @State private var rects = Array<CGRect>(repeating: CGRect(), count: 12)

    var body: some View {
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3.0)
                    .foregroundColor(Color.green)
                    .frame(width: rects[activeIdx].size.width, height: rects[activeIdx].size.height)
                    .offset(x: rects[activeIdx].minX, y: rects[activeIdx].minY)
                    .animation(.easeInOut(duration: 1.0))

            VStack {
                Spacer()

                HStack {
                    MonthView2(activeMonth: $activeIdx, label: "January", idx: 0)
                    MonthView2(activeMonth: $activeIdx, label: "February", idx: 1)
                    MonthView2(activeMonth: $activeIdx, label: "March", idx: 2)
                    MonthView2(activeMonth: $activeIdx, label: "April", idx: 3)
                }

                Spacer()

                HStack {
                    MonthView2(activeMonth: $activeIdx, label: "May", idx: 4)
                    MonthView2(activeMonth: $activeIdx, label: "June", idx: 5)
                    MonthView2(activeMonth: $activeIdx, label: "July", idx: 6)
                    MonthView2(activeMonth: $activeIdx, label: "August", idx: 7)
                }

                Spacer()

                HStack {
                    MonthView2(activeMonth: $activeIdx, label: "September", idx: 8)
                    MonthView2(activeMonth: $activeIdx, label: "October", idx: 9)
                    MonthView2(activeMonth: $activeIdx, label: "November", idx: 10)
                    MonthView2(activeMonth: $activeIdx, label: "December", idx: 11)
                }

                Spacer()
            }
                    .onPreferenceChange(MyTextPreferenceKey.self) { (preferences) in
                        for  p in preferences {
                            rects[p.viewIdx] = p.rect
                        }
                        debugPrint(rects.first?.origin)
                    }

        }.coordinateSpace(name: "MyZSTack")
    }
}



