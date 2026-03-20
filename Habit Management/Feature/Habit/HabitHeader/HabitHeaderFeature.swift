//
//  HabitHeaderFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HabitHeaderFeature {
    struct State: Equatable {
        var userName: String = ""
        var mainReportText: String = "아직 완료된 습관이 없습니다."
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
