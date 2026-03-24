//
//  HabitScrollView.swift
//  Habit Management
//
//  Created by 서충원 on 6/17/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitScrollView: View {
    private let habitStore: StoreOf<HabitFeature>
    private let completionStore: StoreOf<CompletionFeature>

    init(
        habitStore: StoreOf<HabitFeature>,
        completionStore: StoreOf<CompletionFeature>
    ) {
        self.habitStore = habitStore
        self.completionStore = completionStore
    }

    var body: some View {
        WithViewStore(completionStore, observe: \.doneTodayMap) { completionVS in
            WithViewStore(habitStore, observe: { $0 }) { habitVS in
                let sorted = Self.sortHabits(habitVS.habitList, doneMap: completionVS.state)
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer().frame(height: 8)
                    ForEach(sorted, id: \.id) { habit in
                        HabitItemView(
                            habitStore: habitStore,
                            habit: habit,
                            completionStore: completionStore
                        )
                    }
                    Spacer().frame(height: 8)
                }
                .animation(
                    .spring(response: 0.38, dampingFraction: 0.82),
                    value: sorted.compactMap(\.id).joined(separator: "|")
                )
            }
        }
    }
}

private extension HabitScrollView {
    /// 미완료 습관을 위에, 오늘 완료한 습관을 아래에 두고, 각 그룹 안에서는 기존 순서 유지
    static func sortHabits(_ habits: [Habit], doneMap: [String: Bool]) -> [Habit] {
        habits
            .enumerated()
            .sorted { lhs, rhs in
                let lhsDone = doneMap[lhs.element.id ?? ""] == true
                let rhsDone = doneMap[rhs.element.id ?? ""] == true
                if lhsDone != rhsDone {
                    return !lhsDone && rhsDone
                }
                return lhs.offset < rhs.offset
            }
            .map(\.element)
    }
}
