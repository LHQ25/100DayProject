//
// Created by 9527 on 2022/7/29.
//

import SwiftUI

struct MonthView2: View {
    @Binding var activeMonth: Int
    let label: String
    let idx: Int

    var body: some View {

        Text(label)
                .padding(10)
                .background(MyPreferenceViewSetter(idx: idx))
                .onTapGesture { self.activeMonth = idx }
    }
}

struct MyPreferenceViewSetter: View {

    let idx: Int
    var body: some View {

        // 通过GeometryReader来获取文字的大小和位置
        GeometryReader { proxy in
            Rectangle()
                    .fill(Color.red)
                    .cornerRadius(15)
                    // 这些值需要转换一下坐标系，才能绘制出正确的边框。视图可以通过修改器来命名它们的空间坐标系 .coordinateSpace(name: "name")。
                    // 一旦我们转换了rect，我们也要相应的设置preference
                    .preference(key: MyTextPreferenceKey.self, value: [MyTextPreferenceData(viewIdx: idx, rect: proxy.frame(in: .named("MyZSTack")))])

        }
    }
}