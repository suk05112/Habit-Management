//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), showImage: false, habitName: "Default")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        let showImage = defaults?.bool(forKey: "showImage") ?? false
        let habitName = defaults?.string(forKey: "testValue") ?? "Default"
        completion(SimpleEntry(date: Date(), showImage: showImage, habitName: habitName))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.habit-management")
        let showImage = defaults?.bool(forKey: "showImage") ?? false
        let habitName = defaults?.string(forKey: "testValue") ?? "Default"
        let entry = SimpleEntry(date: Date(), showImage: showImage, habitName: habitName)
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let showImage: Bool
    let habitName: String
}

struct ScheduleWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("\(entry.habitName)")
                .font(.headline)
            HStack(spacing: 0) {
                VStack() {
                    Button(intent: ToggleButtonIntent()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.widgetBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                            if entry.showImage {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(width: 80, height: 80)
                    }
                    .tint(.clear)
                    
                    Text("체크하기")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
                VStack() {
                    Button(intent: ToggleButtonIntent()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.widgetBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                            
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.green)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .tint(.clear)
                    
                    Text("체크하기")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
                VStack() {
                    Button(intent: ToggleButtonIntent()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.widgetBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                            
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.green)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .tint(.clear)
                    
                    Text("체크하기")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ToggleButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "토글 상태 변경"

    func perform() async throws -> some IntentResult {
        let current = UserDefaults(suiteName: "group.habit-management")?.bool(forKey: "showImage") ?? true
        UserDefaults(suiteName: "group.habit-management")?.set(!current, forKey: "showImage")
        
        let defaults = UserDefaults(suiteName: "group.habit-management")
        print(defaults?.string(forKey: "testValue") ?? "")
        
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

#Preview(as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, showImage: false, habitName: "")
}
