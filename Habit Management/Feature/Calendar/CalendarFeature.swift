//
//  CalendarFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/12/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarFeature {
    struct State: Equatable {
        var month: CalendarMonthFeature.State = .init()
    }
    
    enum Action: Equatable {
        case month(CalendarMonthFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.month, action: \.month) {
            CalendarMonthFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .month:
                return .none
            }
        }
    }
}
