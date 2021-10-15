//
//  FunDay.swift
//  FunDay
//
//  Created by cbkj on 2021/7/16.
//

import WidgetKit
import SwiftUI


@main
struct FunDay: Widget {
    
    let kind: String = "FunDay"

    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FunDayEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge, .systemMedium, .systemSmall])
        .configurationDisplayName("FunDay")
        .description("fun everyday for you")
    }
}

//struct FunDay_Previews: PreviewProvider {
//    static var previews: some View {
//        FunDayEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
