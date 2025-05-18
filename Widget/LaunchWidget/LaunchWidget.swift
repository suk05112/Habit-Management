//
//  LaunchWidget.swift
//  LaunchWidget
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LaunchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        EmptyView()
            .containerBackground(for: .widget) {
                Image("WidgetFullScreenImage")
                    .resizable()
                    .scaledToFill()
            }
    }
}

struct LaunchWidget: Widget {
    let kind: String = "LaunchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LaunchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit Management")
        .description("Habit Management를 실행합니다.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    LaunchWidget()
} timeline: {
    SimpleEntry(date: .now)
}
