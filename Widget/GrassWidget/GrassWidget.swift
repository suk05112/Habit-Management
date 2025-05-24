//
//  GrassWidget.swift
//  GrassWidget
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import SwiftUI
import HMDesign

enum GrassLevel: Int {
    case empty = 0
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    
    var color: Color {
        switch self {
        case .empty: return Color(.systemGray6)
        case .level1: return Color(red: 0.85, green: 0.95, blue: 0.85)
        case .level2: return Color(red: 0.65, green: 0.85, blue: 0.65)
        case .level3: return Color(red: 0.45, green: 0.75, blue: 0.45)
        case .level4: return Color(red: 0.25, green: 0.65, blue: 0.25)
        }
    }
}

struct GrassEntry: TimelineEntry {
    let date: Date
    let grassData: [[GrassLevel]]
    let family: WidgetFamily
    let theme: GrassTheme
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GrassEntry {
        GrassEntry(date: Date(),
                   grassData: generateRandomGrassData(for: context.family),
                   family: context.family,
                   theme: .classic)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GrassEntry {
        GrassEntry(date: Date(),
                   grassData: generateRandomGrassData(for: context.family),
                   family: context.family,
                   theme: configuration.theme)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GrassEntry> {
        let currentDate = Date()
        let entry = GrassEntry(date: currentDate,
                               grassData: generateRandomGrassData(for: context.family),
                               family: context.family,
                               theme: configuration.theme)
        let nextUpdate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        return timeline
    }
    
    // 위젯 크기에 따른 데이터 생성
    func generateRandomGrassData(for family: WidgetFamily) -> [[GrassLevel]] {
        let columnCount = family == .systemMedium ? 17 : 7
        var data = [[GrassLevel]]()
        
        for _ in 0..<7 {
            var row = [GrassLevel]()
            for _ in 0..<columnCount {
                row.append(GrassLevel(rawValue: Int.random(in: 0...4)) ?? .empty)
            }
            data.append(row)
        }
        return data
    }

    func colorForTheme(level: GrassLevel, theme: GrassTheme) -> Color {
        switch theme {
        case .classic:
            return level.color
        case .dark:
            // 어두운 테마: empty는 검정, 나머지는 진한 녹색 계열
            switch level {
            case .empty: return Color(.systemGray6)
            case .level1: return Color(red: 0.1, green: 0.2, blue: 0.1)
            case .level2: return Color(red: 0.15, green: 0.3, blue: 0.15)
            case .level3: return Color(red: 0.2, green: 0.4, blue: 0.2)
            case .level4: return Color(red: 0.25, green: 0.5, blue: 0.25)
            }
        case .light:
            // 밝은 테마: empty는 흰색, 나머지는 연한 민트 계열
            switch level {
            case .empty: return Color(.systemGray6)
            case .level1: return Color(red: 0.8, green: 1.0, blue: 0.9)
            case .level2: return Color(red: 0.6, green: 0.95, blue: 0.8)
            case .level3: return Color(red: 0.4, green: 0.9, blue: 0.7)
            case .level4: return Color(red: 0.2, green: 0.85, blue: 0.6)
            }
        case .colorful:
            // 컬러풀 테마: 레벨별로 완전히 다른 색상
            switch level {
            case .empty: return Color(.systemGray6)
            case .level1: return .red
            case .level2: return .orange
            case .level3: return .yellow
            case .level4: return .blue
            }
        }
    }
}

struct GrassWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let columnCount = entry.family == .systemMedium ? 17 : 7

        VStack(spacing: 2) {
            ForEach(0..<7) { row in
                HStack(spacing: 2) {
                    ForEach(0..<columnCount, id: \.self) { column in
                        Provider().colorForTheme(level: entry.grassData[row][column], theme: entry.theme)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(2)
                    }
                }
            }
        }
    }
}

struct GrassWidget: Widget {
    let kind: String = "GrassWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                GrassWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                GrassWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("내 습관 잔디")
        .description("내 습관 잔디 현황을 볼 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        
        return intent
    }
}

#Preview(as: .systemSmall) {
    GrassWidget()
} timeline: {
    let provider = Provider()
    GrassEntry(date: .now, 
              grassData: provider.generateRandomGrassData(for: .systemSmall),
              family: .systemSmall,
              theme: .classic)  
}

#Preview(as: .systemMedium) {
    GrassWidget()
} timeline: {
    let provider = Provider()
    GrassEntry(date: .now, 
              grassData: provider.generateRandomGrassData(for: .systemMedium),
              family: .systemMedium,
              theme: .classic)
}
