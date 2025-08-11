//
//  HabitAction.swift
//  Habit Management
//
//  Created by 한수진 on 5/20/25.
//

import Foundation
import ComposableArchitecture
import RealmSwift

@Reducer
struct HabitFeature {
    
    @Dependency(\.habitClient) var habitClient
    
    struct State: Equatable {
        var habitList: [Habit] = []
        var selectedHabit: Habit? = nil
        var mode: Mode = .viewing
        var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
        var mainReportText: String = "아직 완료된 습관이 없습니다."
        var iter: [Int] = []
        var habitTitle: String = "" {
            didSet {
                if habitTitle.count > 9 {
                    habitTitle = String(habitTitle.prefix(8))
                }
            }
        }
        var isToastVisible: Bool = false
        
        var header: HabitHeaderFeature.State = .init()
        var toggle: HabitToggleFeature.State = .init()
        var edit: EditHabitFeature.State = .init()
    }
    
    enum Action: BindableAction {
        case onAppear
        case loadHabits([Habit])
        case setUserName(String)
        case setMainReport(String)
        case setToast(Bool)
        case selectItem(Habit?)
        case setViewMode
        case setEditMode
        case setAddMode
        case addHabit(name: String, iter: [Int])
        case updateHabit(name: String, iter: [Int], habit: Habit)
        case binding(BindingAction<State>)
        case fetchTodayHabitCount
        case fetchedTodayHabitCount(Int)
        case fetchWeeklyHabitStats
        case fetchedWeeklyHabitStats([Int])
        case fetchMonthSummary
        case fetchedMonthSummary(Int, Int)
        case updateContinuity
        case resetContinuity
        case setHabitTitle(String)
        case setIter([Int])
        
        case header(HabitHeaderFeature.Action)
        case toggle(HabitToggleFeature.Action)
        case edit(EditHabitFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.header, action: \.header) {
            HabitHeaderFeature()
        }
        
        Scope(state: \.toggle, action: \.toggle) {
            HabitToggleFeature()
        }
        
        Scope(state: \.edit, action: \.edit) {
            EditHabitFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                let showAll = state.toggle.isShowAll
                let hideCompleted = state.toggle.isHideCompleted
                //                state.mainReportText = ReportData.shared.getMainReport()
                
                return .run { send in
                    let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                    await send(.loadHabits(habits))
                }
                
            case let .loadHabits(habits):
                state.habitList = habits
                return .none
                
            case let .setUserName(name):
                state.userName = name
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
                
            case .setViewMode:
                state.mode = .viewing
                return .none
                
            case .setEditMode:
                state.mode = .editing
                return .none
                
            case .setAddMode:
                state.mode = .adding
                return .none
                
            case let .setHabitTitle(title):
                state.habitTitle = title
                return .none
                
            case let .setIter(iter):
                state.iter = iter
                return .none
                
            case let .addHabit(name, iter):
                let habit = Habit(name: name, iter: iter)
                let showAll = state.toggle.isShowAll
                let hideCompleted = state.toggle.isHideCompleted
                
                return .run { send in
                    try await habitClient.save(habit)
                    let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                    await send(.loadHabits(habits))
                }
                
            case let .updateHabit(name, iter, habit):
                let showAll = state.toggle.isShowAll
                let hideCompleted = state.toggle.isHideCompleted
                
                return .run { send in
                    try await habitClient.update(habit, name, iter)
                    let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                    await send(.loadHabits(habits))
                }
                
            case .binding(_):
                return .none
                
                
            case .fetchTodayHabitCount:
                return .run { send in
                    let count = try await habitClient.todayHabitCount()
                    await send(.fetchedTodayHabitCount(count))
                }
                
            case .fetchedTodayHabitCount:
                return .none
                
            case .fetchWeeklyHabitStats:
                return .run { send in
                    let stats = try await habitClient.weeklyHabitStats()
                    await send(.fetchedWeeklyHabitStats(stats))
                }
                
            case .fetchedWeeklyHabitStats:
                return .none
                
            case .fetchMonthSummary:
                return .run { send in
                    let (thisMonth, lastMonth) = try await habitClient.monthSummary()
                    await send(.fetchedMonthSummary(thisMonth, lastMonth))
                }
                
            case .fetchedMonthSummary:
                return .none
                
            case .updateContinuity:
                return .run { _ in try await habitClient.updateContinuity() }
                
            case .resetContinuity:
                return .run { _ in try await habitClient.resetContinuity() }
                
            case .header:
                return .none
                
            case .toggle(.addHabitButtonPressed):
                state.selectedHabit = nil
                state.mode = .adding
                return .none
                
            case .toggle:
                let showAll = state.toggle.isShowAll
                let hideCompleted = state.toggle.isHideCompleted
                return .run { send in
                    let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                    await send(.loadHabits(habits))
                }
                
            case .edit(let childAction):
                switch childAction {
                case .deleteButtonPressed:
                    state.mode = .viewing
                    state.selectedHabit = nil
                    return .none
                    
                case .didDelete:
                    let showAll = state.toggle.isShowAll
                    let hideCompleted = state.toggle.isHideCompleted
                    return .run { send in
                        let habits = try await habitClient.fetchFiltered(showAll, hideCompleted)
                        await send(.loadHabits(habits))
                    }
                case .editButtonPressed(_):
                    return .none
                case .completeButtonPressed(_):
                    return .none
                }
            }
        }
    }
}
