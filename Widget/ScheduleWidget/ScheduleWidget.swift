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
        SimpleEntry(date: Date(), toggleState: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let state =  UserDefaults(suiteName: "group.your.app.group")?.bool(forKey: "isToggled") ?? false
        completion(SimpleEntry(date: Date(), toggleState: state))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //UserDefaults에서 받는 형식이 좀 다른거같은데..?
        let state = UserDefaults(suiteName: "group.your.app.group")?.bool(forKey: "isToggled") ?? false
        let entry = SimpleEntry(date: Date(), toggleState: state)
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let toggleState: Bool
}

struct ScheduleWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("토글 상태: \(entry.toggleState ? "ON" : "OFF")")
                .font(.headline)
            HStack(spacing: 12) {
                // ⏺ Toggle 역할의 intent button
                Button(intent: ToggleButtonIntent()) {
                    Image(systemName: entry.toggleState ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(entry.toggleState ? .green : .gray)
                }
                
                // ⏺ 일반 버튼 (예: 상태 변경)
                Button(intent: ToggleButtonIntent()) {
                    Text("새로고침")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding()
            .containerBackground(.background, for: .widget)
        }
    }
}

struct ToggleButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "토글 상태 변경"

    func perform() async throws -> some IntentResult {
        // 상태 저장 로직 (UserDefaults, App Group 등 사용해야 함)
        let current = UserDefaults(suiteName: "group.your.app.group")?.bool(forKey: "isToggled") ?? false
        UserDefaults(suiteName: "group.your.app.group")?.set(!current, forKey: "isToggled")
        
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
    SimpleEntry(date: .now, toggleState: true)
    SimpleEntry(date: .now, toggleState: false)
}
