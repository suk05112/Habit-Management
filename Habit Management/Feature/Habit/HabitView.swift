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
    let completionStore: StoreOf<CompletionFeature>
    
    init(
        calendarStore: StoreOf<CalendarFeature>,
        habitStore: StoreOf<HabitFeature>,
        completionStore: StoreOf<CompletionFeature>
    ) {
        self.calendarStore = calendarStore
        self.habitStore = habitStore
        self.completionStore = completionStore
    }

    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            HabitBackgroundView {
                VStack(spacing: 0) {
                    HabitHeaderView(habitStore: habitStore)
                    CalendarView(calendarStore: calendarStore, completionStore: completionStore)
                    HabitToggleView(habitStore: habitStore)
                    HabitScrollView(
                        habitStore: habitStore,
                        completionStore: completionStore
                    )
                    divider
                }
                .toast(
                    message: "Current time: \(DateFormatters.fullName.string(from: Date()))",
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

// MARK: - UI Components
extension HabitView {
    private var divider: some View {
        Rectangle()
            .scaledFrame(width: nil, height: 1)
            .foregroundStyle(Color.gray.opacity(0.2))
            .scaledPadding(top: 0, leading: 0, bottom: 8, trailing: 0)
    }
}
