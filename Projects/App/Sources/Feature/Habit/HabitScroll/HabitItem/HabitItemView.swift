//
//  HabitItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct HabitItemView: View {
    private let habitStore: StoreOf<HabitFeature>
    private let habit: Habit
    private let completionStore: StoreOf<CompletionFeature>
    
    init(
        habitStore: StoreOf<HabitFeature>,
        habit: Habit,
        completionStore: StoreOf<CompletionFeature>
    ) {
        self.habitStore = habitStore
        self.habit = habit
        self.completionStore = completionStore
    }
    
    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            WithViewStore(completionStore, observe: { $0 }) { completionViewStore in
                if !habit.isInvalidated {
                    let habitID = habit.id ?? ""
                    let isDoneToday = completionViewStore.doneTodayMap[habitID] == true
                    let cardShape = RoundedRectangle(cornerRadius: 12)
                    // 카드(둥근 박스)와 완료 버튼 분리 — 탭/롱프레스는 카드 영역에만 적용
                    HStack(alignment: .center, spacing: 12) {
                        habitContentView(
                            name: habit.name,
                            continuity: habit.continuity,
                            weekIter: Array(habit.weekIter),
                            isCompletedToday: isDoneToday
                        )
                        .scaledFrame(width: .none, height: 80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            cardShape
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                        )
                        // 히트 영역을 사각형 전체 행이 아니라 둥근 카드와 동일하게
                        .contentShape(cardShape)
                        .onTapGesture {
                            viewStore.send(.edit(.editButtonPressed(habit)))
                            viewStore.send(.setHabitTitle(habit.name))
                            viewStore.send(.setIter(Array(habit.weekIter)))
                        }
                        .onLongPressGesture(minimumDuration: 0.45) {
                            viewStore.send(.setHabitListReordering(true))
                        }

                        completeButton(
                            viewStore: viewStore,
                            isDoneToday: isDoneToday
                        )
                    }
                    .animation(.easeInOut(duration: 0.22), value: isDoneToday)
                }
            }
        }
    }
}

// MARK: - UI Components
extension HabitItemView {
    func habitContentView(
        name: String,
        continuity: Int,
        weekIter: [Int],
        isCompletedToday: Bool
    ) -> some View {
        let mainText = isCompletedToday ? Color.gray.opacity(0.55) : Color(hex: "2E4A2B")
        let subText = isCompletedToday ? Color.gray.opacity(0.5) : HabitColor.darkGreen.color
        let capsuleText = isCompletedToday ? Color.gray.opacity(0.65) : HabitColor.darkGreen.color
        let capsuleFill = isCompletedToday
            ? Color.gray.opacity(0.12)
            : HabitColor.lightGreen.color.opacity(0.25)
        
        return VStack(alignment: .leading, spacing: 6) {
            Text(displayWeekText(from: weekIter))
                .scaledText(size: 12, weight: .bold)
                .foregroundColor(capsuleText)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(capsuleFill)
                )
            
            HStack {
                Text(name)
                    .scaledText(size: 20, weight: .semibold)
                    .foregroundColor(mainText)
                
                Spacer()
                
                Text(L10n.tr("habit.streak_days", continuity))
                    .scaledText(size: 20, weight: .semibold)
                    .foregroundColor(subText)
                
                Text(L10n.tr("habit.on_fire"))
                    .scaledText(size: 20, weight: .medium)
                    .foregroundColor(isCompletedToday ? Color.gray.opacity(0.45) : .gray.opacity(0.7))
            }
        }
        .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    func displayWeekText(from weekIter: [Int]) -> String {
        let daySet = Set(weekIter)
        let weekdaySet: Set<Int> = [2, 3, 4, 5, 6]
        let everyDaySet: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
        let weekendSet: Set<Int> = [1, 7]
        
        if daySet == weekdaySet {
            return L10n.tr("habit.week.weekdays_only")
        }
        
        if daySet == everyDaySet {
            return L10n.tr("habit.week.every_day")
        }
        
        if daySet == weekendSet {
            return L10n.tr("habit.week.weekends_only")
        }
        
        let orderedDays = weekIter
            .sorted()
            .compactMap { Week(rawValue: $0)?.kor }
        return orderedDays.joined(separator: ", ")
    }
    
    func completeButton(
        viewStore: ViewStore<HabitFeature.State, HabitFeature.Action>,
        isDoneToday: Bool
    ) -> some View {
        let mainGreen = HabitColor.defaultGreen.color
        let completedFill = Color.gray.opacity(0.32)
        let completedCheck = Color.gray.opacity(0.78)

        return Button {
            viewStore.send(.edit(.completeButtonPressed(habit)))
        } label: {
            ZStack {
                if isDoneToday {
                    Circle()
                        .fill(completedFill)
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(completedCheck)
                } else {
                    Circle()
                        .fill(Color.white)
                    Circle()
                        .stroke(mainGreen, lineWidth: 2.5)
                }
            }
            .scaledFrame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 10)
    }
}
