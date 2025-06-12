//
//  HabitView.swift
//  Habit Management
//
//  Created by 한수진 on 5/20/25.
//

import SwiftUI
import CoreData
import RealmSwift
import Firebase
import ComposableArchitecture

struct HabitView: View {
    let habitStore: StoreOf<HabitFeature>
    let statisticsStore: StoreOf<StatisticsFeature>
    
    init(habitStore: StoreOf<HabitFeature>, statisticsStore: StoreOf<StatisticsFeature>) {
        self.habitStore = habitStore
        self.statisticsStore = statisticsStore
    }

    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            HabitBackgroundView {
                VStack(spacing: 16) {
                    HabitHeaderView(store: habitStore.scope(state: \.header, action: \.header))
                    GridView(store: statisticsStore)
                    MainToggleBar(
                        showAll: viewStore.binding(
                            get: \.isShowingAllHabits,
                            send: .toggleShowAll
                        ),
                        hideCompleted: viewStore.binding(
                            get: \.isHidingCompletedHabits,
                            send: .toggleHideCompleted
                        ),
                        toggleShowAll: {
                            habitStore.send(.toggleShowAll)
                        },
                        toggleHideCompleted: {
                            habitStore.send(.toggleHideCompleted)
                        }
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(viewStore.state.habitList) { habit in
                            ZStack {
                                ItemView(
                                    store: habitStore,
                                    habit: habit
                                )
                            }
                        }
                    }
                    
                    MainAddButton {
                        habitStore.send(.selectItem(nil))
                        habitStore.send(.setEditMode(false))
                        habitStore.send(.setAddMode(true))
                    }
                    
                    Spacer()
                }
                .toast(
                    message: "Current time:\n\(Date().formatted(date: .complete, time: .complete))",
                    isShowing: viewStore.binding(
                        get: \.isToastVisible,
                        send: { .setToast($0) }
                    ),
                    duration: Toast.long
                )
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            }
        }
    }
}

struct MainToggleBar: View {
    @Binding var showAll: Bool
    @Binding var hideCompleted: Bool
    var toggleShowAll: () -> Void
    var toggleHideCompleted: () -> Void

    var body: some View {
        HStack {
            Text(showAll ? "예정된 습관만 보기" : "습관 모두 보기")
                .onTapGesture {
                    toggleShowAll()
                }
            Spacer()
            Text(hideCompleted ? "완료된 항목 보이기" : "완료된 항목 숨기기")
                .onTapGesture {
                    toggleHideCompleted()
                }
        }
        .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
    }
}

struct MainAddButton: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.black)
        }
        .scaledPadding(top: 5, leading: 0, bottom: 5, trailing: 0)
    }
}
