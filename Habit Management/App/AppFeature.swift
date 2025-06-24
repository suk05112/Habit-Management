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
    struct State: Equatable {
        var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
        var hasLaunched: Bool = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        var calendar: CalendarFeature.State = .init()
        var habit: HabitFeature.State = .init()
        var statistics: StatisticsFeature.State = .init()
        var completion: CompletionFeature.State = .init()
    }
    
    enum Action: BindableAction {
        case task
        case setUserName(String)
        case setHasLaunched(Bool)
        case calendar(CalendarFeature.Action)
        case habit(HabitFeature.Action)
        case statistics(StatisticsFeature.Action)
        case completion(CompletionFeature.Action)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.calendar, action: \.calendar) {
            CalendarFeature()
        }
        
        Scope(state: \.habit, action: \.habit) {
            HabitFeature()
        }
        
        Scope(state: \.statistics, action: \.statistics) {
            StatisticsFeature()
        }
        
        Scope(state: \.completion, action: \.completion) {
            CompletionFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .task:
                return .merge(
                    .send(.statistics(.onAppear))
                )
            case let .setUserName(name):
                state.userName = name
                UserDefaults.standard.set(name, forKey: "userName")
                return .none
                
            case let .setHasLaunched(flag):
                state.hasLaunched = flag
                UserDefaults.standard.set(flag, forKey: "hasLaunchedBefore")
                return .none
                
            case .calendar:
                return .none
                
            case .habit:
                return .none
                
            case .statistics:
                return .none
                
            case .completion:
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
