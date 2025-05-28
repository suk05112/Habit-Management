//
//  HabitAction.swift
//  Habit Management
//
//  Created by 한수진 on 5/20/25.
//

import Foundation
import ComposableArchitecture
import RealmSwift


struct HabitFeature: Reducer {
    struct State: Equatable {
        var habitList: [Habit] = []
        var selectedHabit: Habit? = nil
        var isShowingAllHabits: Bool = false
        var isHidingCompletedHabits: Bool = false
        var isEditingHabit: Bool = false
        var userName: String = "사용자"
        var mainReportText: String = ""
        
        @BindingState var isToastVisible: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case onAppear
        case loadHabits([Habit])
        case toggleShowAll
        case toggleHideCompleted
        case setUserName(String)
        case setMainReport(String)
        case setToast(Bool)
        case selectItem(Habit?)
        case setEditMode(Bool)
        case addHabit(name: String, iter: [Int])
        case updateHabit(name: String, iter: [Int], habit: Habit)
        case deleteHabit(Habit)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\..habitClient) var habitClient
    @Dependency(\..completionClient) var completionClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .loadHabits(habits):
            state.habitList = habits
            return .none
            
        case .toggleShowAll:
            state.isShowingAllHabits.toggle()
            UserDefaults.standard.set(state.isShowingAllHabits, forKey: "isShowingAllHabits")
            
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case .toggleHideCompleted:
            state.isHidingCompletedHabits.toggle()
            UserDefaults.standard.set(state.isHidingCompletedHabits, forKey: "isHidingCompletedHabits")
            
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
            
        case let .setUserName(name):
            state.userName = name
            UserDefaults.standard.set(name, forKey: "userName")
            return .none
            
        case let .setMainReport(report):
            state.mainReportText = report
            return .none
            
        case let .setToast(flag):
            state.isToastVisible = flag
            return .none
            
        case let .selectItem(habit):
            state.selectedHabit = habit
            return .none
            
        case let .setEditMode(flag):
            state.isEditingHabit = flag
            return .none
            
        case let .addHabit(name, iter):
            let habit = Habit(name: name, iter: iter)
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                try await habitClient.save(habit)
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .updateHabit(name, iter, habit):
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                try await habitClient.update(habit, name, iter)
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .deleteHabit(habit):
            let showAll = state.isShowingAllHabits
            let hideCompleted = state.isHidingCompletedHabits
            
            return .run { send in
                try await habitClient.delete(habit)
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case .binding(_):
            return .none
        }
    }
}
