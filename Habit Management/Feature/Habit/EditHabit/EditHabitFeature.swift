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
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    struct State: Equatable {
        var mode: Mode = .viewing
        var selectedHabit: Habit? = nil
    }
    
    enum Action: Equatable {
        case deleteButtonPressed(Habit)
        case editButtonPressed(Habit)
        case completeButtonPressed(Habit)
        case didDelete
        case didComplete
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .deleteButtonPressed(habit):
                state.mode = .viewing
                return .run { send in
                    try await habitClient.delete(habit)
                    if habit.today() {
                        let key = "allDoneContinuity"
                        let continuity = max(userDefaultsClient.integerForKey(key) - 1, 0)
                        userDefaultsClient.setInteger(continuity, key)
                    }
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
                    if habit.today() {
                        let key = "allDoneContinuity"
                        let continuity = max(userDefaultsClient.integerForKey(key) - 1, 0)
                        userDefaultsClient.setInteger(continuity, key)
                    }
                    await send(.didComplete)

                }
            case .didDelete:
                return .none
            case .didComplete:
                return .none
            }
        }
    }
}
