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
                let pairs = Self.partitioned(
                    habitVS.habitList,
                    doneMap: completionVS.state
                )
                let incomplete = pairs.incomplete
                let completed = pairs.completed

                ZStack(alignment: .topTrailing) {
                    List {
                        // 미완료: 위쪽, 섹션 안에서만 드래그로 순서 변경
                        Section {
                            ForEach(
                                Array(
                                    incomplete.compactMap { h -> (String, Habit)? in
                                        guard let id = h.id else { return nil }
                                        return (id, h)
                                    }
                                ),
                                id: \.0
                            ) { _, habit in
                                HabitItemView(
                                    habitStore: habitStore,
                                    habit: habit,
                                    completionStore: completionStore
                                )
                                // ScrollView 때와 비슷하게 위·아래 여백 유지 (4pt는 카드가 눌려 보임)
                                .listRowInsets(
                                    EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                )
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onMove { source, destination in
                                var next = incomplete
                                next.move(fromOffsets: source, toOffset: destination)
                                let ids = next.compactMap(\.id)
                                habitVS.send(.reorderIncompleteSection(ids))
                            }
                        }

                        // 완료: 아래쪽 (미완료 위로는 올라갈 수 없음)
                        if !completed.isEmpty {
                            Section {
                                ForEach(
                                    Array(
                                        completed.compactMap { h -> (String, Habit)? in
                                            guard let id = h.id else { return nil }
                                            return (id, h)
                                        }
                                    ),
                                    id: \.0
                                ) { _, habit in
                                    HabitItemView(
                                        habitStore: habitStore,
                                        habit: habit,
                                        completionStore: completionStore
                                    )
                                    .listRowInsets(
                                        EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                    )
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                .onMove { source, destination in
                                    var next = completed
                                    next.move(fromOffsets: source, toOffset: destination)
                                    let ids = next.compactMap(\.id)
                                    habitVS.send(.reorderCompletedSection(ids))
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    // 시스템 기본 행 높이(44)에 맞춰지며 카드(80 스케일)가 잘리는 것 방지
                    .environment(\.defaultMinListRowHeight, 0)
                    .modifier(HabitListClearBackgroundModifier())
                    .environment(
                        \.editMode,
                        Binding(
                            get: {
                                habitVS.isHabitListReordering ? .active : .inactive
                            },
                            set: { newMode in
                                habitVS.send(.setHabitListReordering(newMode == .active))
                            }
                        )
                    )
                    .animation(
                        .spring(response: 0.38, dampingFraction: 0.82),
                        value: incomplete.compactMap(\.id).joined(separator: "|")
                            + "|"
                            + completed.compactMap(\.id).joined(separator: "|")
                    )

                    // 순서 편집 중에는 시스템 Done 외에도 한눈에 끝낼 수 있게
                    if habitVS.isHabitListReordering {
                        Button {
                            habitVS.send(.setHabitListReordering(false))
                        } label: {
                            Text("완료")
                                .scaledText(size: 15, weight: .semibold)
                                .foregroundStyle(HabitColor.defaultGreen.color)
                                .scaledPadding(top: 4, leading: 12, bottom: 4, trailing: 12)
                                .background(
                                    Capsule().fill(Color.white.opacity(0.92))
                                )
                        }
                        .buttonStyle(.plain)
                        .scaledPadding(top: 4, leading: 0, bottom: 0, trailing: 20)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}

private extension HabitScrollView {
    /// 미완료 / 완료로 나누고, 각 그룹 안에서는 sortOrder → id
    static func partitioned(
        _ habits: [Habit],
        doneMap: [String: Bool]
    ) -> (incomplete: [Habit], completed: [Habit]) {
        let incomplete = habits
            .filter { doneMap[$0.id ?? ""] != true }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return ($0.id ?? "") < ($1.id ?? "")
            }
        let completed = habits
            .filter { doneMap[$0.id ?? ""] == true }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return ($0.id ?? "") < ($1.id ?? "")
            }
        return (incomplete, completed)
    }
}

/// iOS 15에서는 스크롤 배경 제거 API가 없어 16+만 적용
private struct HabitListClearBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
