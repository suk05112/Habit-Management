//
//  EditFeature.swift
//  Habit Management
//
//  Created by 남경민 on 6/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EditHabitFeature {
    
    @Dependency(\.habitClient) var habitClient
    
    struct State: Equatable {
        var mode: Mode = .viewing
        var selectedHabit: Habit? = nil
    }
    
    enum Action: Equatable {
        case deleteButtonPressed(Habit)
        case editButtonPressed(Habit)
        case completeButtonPressed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .deleteButtonPressed(habit):
                return .run { send in
                    try await habitClient.delete(habit)
                    /// 로직을 다시 구현해야 함
                    //compltedLIstVM.shared.setIsToday(isToday: todayHabit())
                    //compltedLIstVM.shared.setAllDoneContinuityUntilToday(status: .delete, isToday: todayHabit())
                }
            case let .editButtonPressed(habit):
                state.mode = .editing
                state.selectedHabit = habit
                return .none
            
            case .completeButtonPressed:
                /// 로직을 다시 구현해야 함
                //compltedLIstVM.shared.setIsToday(isToday: todayHabit())
                //self.check(myItem.id!)

                //HabitVM.shared.setContiuity(at: habit)
                //HabitVM.shared.fetchItem()
                return .none
            }
        }
    }
}
