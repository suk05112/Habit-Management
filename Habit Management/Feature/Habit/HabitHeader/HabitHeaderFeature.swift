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
        
        // Equatable 명시적 구현
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.userName == rhs.userName
        }
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("이전 userName: \(state.userName)")  // 디버깅용
                state.userName = "테스트유저이름"
                print("변경된 userName: \(state.userName)")  // 디버깅용
                return .none
            }
        }
    }
}
