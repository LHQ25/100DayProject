//
//  MonthView2.swift
//  SwiftUI_ViewTree_AnchorPreferences
//
//  Created by 9527 on 2022/7/29.
//

import SwiftUI

/*
 我们知道Anchor 的值不止有bounds，还有topLeading, center, bottom等值。
 可能有的情况下我们需要的不止一个Anchor 的值，然而，调用它并不像调用.anchorPreference() 一样容易。下面我们举例继续说明。
 我们将使用两个不同的 Anchor，来获取月份标签的bounds， 其中一个左上角的Point 一个是右下角的 Point。而不是用Anchor。
 提醒一下，使用Anchor是对这种特定问题的一个更好的解决方案。然而，我们用CGPoint方案只是为了知道如何获取一个视图的多个锚定偏好
 */
struct MyTextPreferenceData2 {
    let viewIdx: Int
    var topLeading: Anchor<CGPoint>? = nil
    var bottomTrailing: Anchor<CGPoint>? = nil
}

struct MyTextPreferenceKey2: PreferenceKey {
    
    typealias Value = [MyTextPreferenceData2]
    
    static var defaultValue: [MyTextPreferenceData2] = []
    
    static func reduce(value: inout [MyTextPreferenceData2], nextValue: () -> [MyTextPreferenceData2]) {
        value.append(contentsOf: nextValue())
    }
}

struct MonthView2: View {
    
    @Binding var activeMonth: Int
    let label: String
    let idx: Int
    
    var body: some View {
        Text(label)
            .padding(10)
            // 月份标签没必要设置两个锚定偏好，但是如果我们在同一个视图中多次调用.anchorPreference()。
            // 只有最后一次起作用。 相反我们需要调用 .anchorPreference(), 然后再调用.transformAnchorPreference(),来补回缺失的信息
            .anchorPreference(key: MyTextPreferenceKey2.self, value: .topLeading, transform: { anchor in
                [MyTextPreferenceData2(viewIdx: idx, topLeading: anchor)]
            })
            .transformAnchorPreference(key: MyTextPreferenceKey2.self, value: .bottomTrailing) { value, anchor in
                value[0].bottomTrailing = anchor
            }
            .onTapGesture {
                self.activeMonth = idx
            }
    }
}
