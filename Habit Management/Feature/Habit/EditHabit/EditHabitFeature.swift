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
        case deleteHabit(Habit)
        case editButtonPressed(Habit)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .deleteHabit(habit):                
                return .run { send in
                    try await habitClient.delete(habit)
                }
            case let .editButtonPressed(habit):
                state.mode = .editing
                state.selectedHabit = habit
                return .none
            }
        }
    }
}
