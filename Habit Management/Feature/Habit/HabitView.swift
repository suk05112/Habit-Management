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
    let calendarStore: StoreOf<CalendarFeature>
    let habitStore: StoreOf<HabitFeature>
    let statisticsStore: StoreOf<StatisticsFeature>
    
    init(calendarStore: StoreOf<CalendarFeature>, habitStore: StoreOf<HabitFeature>, statisticsStore: StoreOf<StatisticsFeature>) {
        self.calendarStore = calendarStore
        self.habitStore = habitStore
        self.statisticsStore = statisticsStore
    }

    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            HabitBackgroundView {
                VStack(spacing: 12) {
                    HabitHeaderView(habitStore: habitStore)
                    CalendarView(calendarStore: calendarStore)
                    HabitToggleView(habitStore: habitStore)
                    
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
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
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
