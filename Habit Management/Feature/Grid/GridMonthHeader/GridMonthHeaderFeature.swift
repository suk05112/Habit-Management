//
//  GridMonthHeaderFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GridMonthHeaderFeature {
    struct State: Equatable {
        var monthArray: [String] = Array(repeating: "a", count: 20)
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
