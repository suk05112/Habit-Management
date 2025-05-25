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
        var habits: [Habit] = []
        var showAll: Bool = UserDefaults.standard.bool(forKey: "showAll")
        var hideCompleted: Bool = UserDefaults.standard.bool(forKey: "hideCompleted")
        var selectedItem: Habit? = nil
        @BindingState var showToast: Bool = false
        var isEdit: Bool = false
        var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "사용자"
        var mainReport: String = ReportData.shared.getMainReport()
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
            
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .loadHabits(habits):
            state.habits = habits
            return .none
            
        case .toggleShowAll:
            state.showAll.toggle()
            UserDefaults.standard.set(state.showAll, forKey: "showAll")
            
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case .toggleHideCompleted:
            state.hideCompleted.toggle()
            UserDefaults.standard.set(state.hideCompleted, forKey: "hideCompleted")
            
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
            return .run { send in
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
            
        case let .setUserName(name):
            state.userName = name
            UserDefaults.standard.set(name, forKey: "userName")
            return .none
            
        case let .setMainReport(report):
            state.mainReport = report
            return .none
            
        case let .setToast(flag):
            state.showToast = flag
            return .none
            
        case let .selectItem(habit):
            state.selectedItem = habit
            return .none
            
        case let .setEditMode(flag):
            state.isEdit = flag
            return .none
            
        case let .addHabit(name, iter):
            let habit = Habit(name: name, iter: iter)
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
            return .run { send in
                try await habitClient.save(habit)
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .updateHabit(name, iter, habit):
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
            return .run { send in
                try await habitClient.update(habit, name, iter)
                let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                await send(.loadHabits(habits))
            }
            
        case let .deleteHabit(habit):
            let showAll = state.showAll
            let hideCompleted = state.hideCompleted
            
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
