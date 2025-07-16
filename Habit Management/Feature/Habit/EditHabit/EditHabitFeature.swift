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

    @DBActor @Dependency(\.realmClient) var realmClient
    
    struct State: Equatable {
        var mode: Mode = .viewing
        var selectedHabit: Habit? = nil
    }
    
    enum Action: Equatable {
        case deleteButtonPressed(Habit)
        case editButtonPressed(Habit)
        case completeButtonPressed(Habit)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .deleteButtonPressed(habit):
                state.mode = .viewing
                return .run { send in
                    await realmClient.deleteHabit(habit)
                    _ = await realmClient.getContinuity(status: .delete, isToday: habit.today())
                }
            case let .editButtonPressed(habit):
                state.mode = .editing
                state.selectedHabit = habit
                return .none
                
            case let .completeButtonPressed(habit):
                state.mode = .viewing
                return .run { send in
                    await realmClient.toggleCompleted(id: habit.id!)
                    _ = await realmClient.getContinuity(status: .complete, isToday: habit.today())
                }
            }
        }
    }
}
