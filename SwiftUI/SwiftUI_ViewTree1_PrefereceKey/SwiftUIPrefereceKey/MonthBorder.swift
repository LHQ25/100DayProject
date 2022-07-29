//
// Created by 9527 on 2022/7/29.
//

import SwiftUI

struct MonthBorder: View {
    let show: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 3.0).foregroundColor(show ? Color.red : Color.clear)
                .animation(.easeInOut(duration: 0.6))
    }
}
