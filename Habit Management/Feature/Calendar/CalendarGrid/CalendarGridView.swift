//
//  CalendarGridView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct CalendarGridView: View {
    private let store: StoreOf<CalendarGridFeature>
    private let completionStore: StoreOf<CompletionFeature>

    @EnvironmentObject var setting: Setting

    init(store: StoreOf<CalendarGridFeature>, completionStore: StoreOf<CompletionFeature>) {
        self.store = store
        self.completionStore = completionStore
    }

    var body: some View {
        WithViewStore(completionStore, observe: \.refreshTick) { completionViewStore in
            WithViewStore(store, observe: \.dayItemArray) { viewStore in
                let dayItemArray = viewStore.state
                let weekdayTotals = RealmCalendarQueries.habitsScheduledCountByWeekday()
                let allDates = dayItemArray.flatMap { $0.map(\.date) }.filter { !$0.isEmpty }
                let completionCounts = RealmCalendarQueries.completionCounts(for: allDates)
                // 색은 여기서 1회만 계산 (SwiftUI가 셀 body를 여러 번 평가해도 DateFormatter/요일 계산이 반복되지 않음)
                let colorByDate = Self.makeColorByDate(
                    dates: allDates,
                    completionCounts: completionCounts,
                    weekdayTotals: weekdayTotals
                )
                let cellWidth = setting.frameSize * setting.widthRatio
                let cellHeight = setting.frameSize * setting.heightRatio
                let cellCorner = setting.ratioSpacing

                ForEach(dayItemArray, id: \.self) { week in
                    VStack(spacing: setting.ratioSpacing) {
                        ForEach(week, id: \.id) { dayItem in
                            gridItem(
                                dayItem.date,
                                colorByDate: colorByDate,
                                cellWidth: cellWidth,
                                cellHeight: cellHeight,
                                cornerRadius: cellCorner
                            )
                        }
                    }
                    .scaledPadding(top: 0, leading: 0, bottom: 12, trailing: 0)
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .id(completionViewStore.state)
            }
        }
    }

    /// `yyyy-MM-dd` → 요일(1…7). `DateFormatter` 없이 `Calendar`만 사용.
    private static func weekday(fromYMD date: String) -> Int? {
        let parts = date.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 3,
              let y = Int(parts[0]), let m = Int(parts[1]), let d = Int(parts[2]),
              let gd = Calendar.current.date(from: DateComponents(year: y, month: m, day: d))
        else { return nil }
        return Calendar.current.component(.weekday, from: gd)
    }

    private static func cellColor(
        date: String,
        completedCount: Int,
        weekdayTotals: [Int: Int]
    ) -> Color {
        guard let weekday = weekday(fromYMD: date) else {
            return HabitColor.defaultGray.color
        }
        let total = weekdayTotals[weekday] ?? 0

        guard total > 0 else {
            return completedCount == 0 ? HabitColor.defaultGray.color : HabitColor.lightGreen.color
        }

        let percent = (Double(completedCount) / Double(total)) * 100

        if completedCount == 0 {
            return HabitColor.defaultGray.color
        } else if percent < 33 {
            return HabitColor.lightGreen.color
        } else if percent > 33 && percent < 66 {
            return HabitColor.mediumGreen.color
        } else {
            return HabitColor.darkGreen.color
        }
    }

    private static func makeColorByDate(
        dates: [String],
        completionCounts: [String: Int],
        weekdayTotals: [Int: Int]
    ) -> [String: Color] {
        var dict: [String: Color] = [:]
        dict.reserveCapacity(dates.count)
        for date in dates {
            let count = completionCounts[date] ?? 0
            dict[date] = cellColor(date: date, completedCount: count, weekdayTotals: weekdayTotals)
        }
        return dict
    }
}

// MARK: - UI Components
extension CalendarGridView {
    func gridItem(
        _ date: String,
        colorByDate: [String: Color],
        cellWidth: CGFloat,
        cellHeight: CGFloat,
        cornerRadius: CGFloat
    ) -> some View {
        let fillColor = date.isEmpty
            ? HabitColor.defaultGreen.color
            : (colorByDate[date] ?? HabitColor.defaultGray.color)
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillColor)
            .frame(width: cellWidth, height: cellHeight)
    }
}
