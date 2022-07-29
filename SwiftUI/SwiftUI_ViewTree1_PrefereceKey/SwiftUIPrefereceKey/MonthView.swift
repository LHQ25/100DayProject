//
// Created by 9527 on 2022/7/29.
//

import SwiftUI

struct MonthView: View {
    @Binding var activeMonth: Int
    let label: String
    let idx: Int

    var body: some View {
        Text(label)
                .padding(10)
                .animation(.easeInOut(duration: 0.2))
                .onTapGesture { self.activeMonth = self.idx }
                .background(MonthBorder(show: activeMonth == idx))
    }
}
