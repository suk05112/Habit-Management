//
//  GridMonthFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GridMonthFeature {
    struct State: Equatable {
        var today = Date().formatted(date: .numeric, time: .omitted)
        var monthArray: [String] = Array(repeating: "a", count: 30)
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.monthArray = Array(repeating: "b", count: 30)
                print(state.today)
                return .none
            }
        }
    }
}

// MARK: - Actions
extension GridMonthFeature {
    private func onAppearAction(state: inout State) -> Effect<Action> {
        state.monthArray = Array(repeating: "b", count: 30)
        print(state.today)
        return .none
    }
}
