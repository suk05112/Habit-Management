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
        var grid: CalendarGridFeature.State = .init()
    }
    
    enum Action: Equatable {
        case month(CalendarMonthFeature.Action)
        case grid(CalendarGridFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.month, action: \.month) {
            CalendarMonthFeature()
        }
        
        Scope(state: \.grid, action: \.grid) {
            CalendarGridFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}
