//
//  GrassWidget.swift
//  GrassWidget
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import SwiftUI

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
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GrassEntry {
        GrassEntry(date: Date(), 
                  grassData: generateRandomGrassData(for: context.family),
                  family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (GrassEntry) -> ()) {
        let entry = GrassEntry(date: Date(), 
                             grassData: generateRandomGrassData(for: context.family),
                             family: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = GrassEntry(date: currentDate, 
                             grassData: generateRandomGrassData(for: context.family),
                             family: context.family)
        
        let nextUpdate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
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
}

struct GrassWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let columnCount = entry.family == .systemMedium ? 17 : 7

        VStack(spacing: 2) {
            ForEach(0..<7) { row in
                HStack(spacing: 2) {
                    ForEach(0..<columnCount, id: \.self) { column in
                        entry.grassData[row][column].color
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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

#Preview(as: .systemSmall) {
    GrassWidget()
} timeline: {
    let provider = Provider()
    GrassEntry(date: .now, 
              grassData: provider.generateRandomGrassData(for: .systemSmall),
              family: .systemSmall)
}

#Preview(as: .systemMedium) {
    GrassWidget()
} timeline: {
    let provider = Provider()
    GrassEntry(date: .now, 
              grassData: provider.generateRandomGrassData(for: .systemMedium),
              family: .systemMedium)
}
