//
//  HabitAddFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/24/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HabitAddFeature {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case backgroundPressed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backgroundPressed:
                return .none
            }
        }
    }
}
