//
// Created by 9527 on 2022/7/29.
//

import SwiftUI

/*
 首先迎来的是Anchor< T >, 这是存放泛型T的不透明的类型。
 这里的T可以是CGRect或者是CGPoint。
 我们一般使用Anchor来获得视图的大小，用Anchor来获取例top, topLeading, topTrailing, center, trailing, bottom, bottomLeading, bottomTrailing, leading属性。
 因为这是不透明类型，所以我们不能单独使用它。还记得之前的文章GeometryReader to the Rescue文章中GeometryProxy的通过下标getter方法么。
 当使用Anchor的值作为 geometry proxy 的索引时，你就可以获得CGRect和CGPoint的值。
 此外，你还可以获取它们在GeometryReader视图中的空间坐标。
 */
struct MyTextPreferenceData {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
}

// PreferenceKey 保持不变
struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MonthView: View {
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
            // 把MonthView的.preference()替换成.anchorPreference()。
            // 和其他方法不同，这里我们可以指定一个值(例子里面指定的是.bounds)。 那么我们transform这闭包中的Anchor就是修改视图的bounds
                .anchorPreference(key: MyTextPreferenceKey.self, value: .bounds) { (anchor) in
                    [MyTextPreferenceData(viewIdx: idx, bounds: anchor)]
                }
        }
    }
}
