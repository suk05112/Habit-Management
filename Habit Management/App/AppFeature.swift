//
//  AppFeature.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
        var hasLaunched: Bool = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        var habit: HabitFeature.State = .init()
    }
    
    enum Action: BindableAction {
        case setUserName(String)
        case setHasLaunched(Bool)
        
        case habit(HabitFeature.Action)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.habit, action: /Action.habit) {
            HabitFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .setUserName(name):
                state.userName = name
                UserDefaults.standard.set(name, forKey: "userName")
                return .none
                
            case let .setHasLaunched(flag):
                state.hasLaunched = flag
                UserDefaults.standard.set(flag, forKey: "hasLaunchedBefore")
                return .none
                
            case .habit:
                return .none
                
            case .binding(_):
                return .none
            }
            
        }
    }
}
