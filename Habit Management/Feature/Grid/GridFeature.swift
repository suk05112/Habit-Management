//
//  GridFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/12/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GridFeature {
    struct State: Equatable {
        var month: GridMonthFeature.State = .init()
    }
    
    enum Action: Equatable {
        case month(GridMonthFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.month, action: \.month) {
            GridMonthFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .month:
                return .none
            }
        }
    }
}
