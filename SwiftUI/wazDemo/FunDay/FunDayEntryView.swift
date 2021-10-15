//
//  FunDayEntryView.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/16.
//

import SwiftUI
import Intents
import WidgetKit

struct FunDayEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}
