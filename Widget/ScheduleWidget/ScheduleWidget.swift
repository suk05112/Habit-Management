//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import SwiftUI
import AppIntents
import HMDesign

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleWidgetEntry {
        ScheduleWidgetEntry(date: Date(), remainHabitCount: 0, showImage: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleWidgetEntry) -> ()) {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        let count = defaults?.integer(forKey: "habitCount") ?? 0
        let showImage = defaults?.bool(forKey: "showImage") ?? false
        
        completion(ScheduleWidgetEntry(date: Date(), remainHabitCount: count, showImage: showImage))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        
        let count = defaults?.integer(forKey: "habitCount") ?? 0
        let showImage = defaults?.bool(forKey: "showImage") ?? false
        
        let entry = ScheduleWidgetEntry(date: Date(), remainHabitCount: count, showImage: showImage)
        
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

struct ScheduleWidgetEntry: TimelineEntry {
    let date: Date
    let remainHabitCount: Int
    let showImage: Bool
}

struct ScheduleWidgetEntryView : View {
    var entry: Provider.Entry
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack {
                Text("Habit Management")
                    .foregroundColor(hex: "#9ECAA4")
                    .fontWeight(.bold)
                    .font(.system(size: 16, design: .rounded))
                
                Spacer()
                Text("\(entry.remainHabitCount)")
                    .foregroundColor(hex: "#36793F")
                    .fontWeight(.bold)
                    .font(.system(size: 24, design: .rounded))
                    .contentTransition(.numericText())
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            HStack(spacing: 0) {
                HabitCheckView(entry: entry)
                HabitCheckView(entry: entry)
                HabitCheckView(entry: entry)
//                Button(intent: ReduceHabitCountIntent()) {
//                    Text("reduce")
//                }
            }
        }
    }
}

struct ToggleButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "토글 상태 변경"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        let current = defaults?.bool(forKey: "showImage") ?? false
        defaults?.set(!current, forKey: "showImage")
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct ReduceHabitCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Habit Count Reduce"
    
    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        var count: Int = defaults?.integer(forKey: "habitCount") ?? 0
        count -= 1
        defaults?.set(count, forKey: "habitCount")
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("오늘의 일정 확인")
        .description("오늘의 일정을 확인하고 완료 체크를 할 수 있습니다.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    ScheduleWidget()
} timeline: {
    ScheduleWidgetEntry(date: .now, remainHabitCount: 0, showImage: false)
}
