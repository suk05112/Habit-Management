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
    @Dependency(\.completionClient) var completionClient
    
    struct State: Equatable {
        var mode: Mode = .viewing
        var selectedHabit: Habit? = nil
    }
    
    enum Action: Equatable {
        case deleteButtonPressed(Habit)
        case editButtonPressed(Habit)
        case completeButtonPressed(Habit)
        case didDelete
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .deleteButtonPressed(habit):
                state.mode = .viewing
                return .run { send in
                    try await habitClient.delete(habit)
                    try await completionClient.updateAllDoneContinuity(.delete, habit.today())
                    await send(.didDelete)
                }
            case let .editButtonPressed(habit):
                state.mode = .editing
                state.selectedHabit = habit
                return .none
                
            case let .completeButtonPressed(habit):
                state.mode = .viewing
                return .run { send in
                    try await completionClient.toggle(habit.id!)
                    try await completionClient.updateAllDoneContinuity(.delete, habit.today())
                }
            case .didDelete:
                return .none
            }
        }
    }
}
