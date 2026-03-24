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
                    HStack(alignment: .center, spacing: 12) {
                        habitContentView(
                            name: habit.name,
                            continuity: habit.continuity,
                            weekIter: Array(habit.weekIter),
                            isCompletedToday: isDoneToday
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewStore.send(.edit(.editButtonPressed(habit)))
                            viewStore.send(.setHabitTitle(habit.name))
                            viewStore.send(.setIter(Array(habit.weekIter)))
                        }
                        
                        completeButton(
                            viewStore: viewStore,
                            isDoneToday: isDoneToday
                        )
                    }
                    .scaledFrame(width: .none, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
                    .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
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
                
                Text("\(continuity)일")
                    .scaledText(size: 20, weight: .semibold)
                    .foregroundColor(subText)
                
                Text("실천 중🔥")
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
            return "평일만"
        }
        
        if daySet == everyDaySet {
            return "매일"
        }
        
        if daySet == weekendSet {
            return "주말만"
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
