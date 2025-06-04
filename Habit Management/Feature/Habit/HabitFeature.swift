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
    @ObservableState
    struct State: Equatable {
        var habitList: [Habit] = []
        var selectedHabit: Habit? = nil
        var isShowingAllHabits: Bool = false
        var isShowingAdd: Bool = false
        var isHidingCompletedHabits: Bool = false
        var isEditingHabit: Bool = false
        var userName: String = "사용자"
        var mainReportText: String = ""
        var iter: [Int] = []
        var habitTitle: String = "" {
            didSet {
                if habitTitle.count > 9 {
                    habitTitle = String(habitTitle.prefix(8))
                }
            }
        }
        var isToastVisible: Bool = false
        
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.habitList == rhs.habitList &&
            lhs.isShowingAllHabits == rhs.isShowingAllHabits &&
            lhs.isHidingCompletedHabits == rhs.isHidingCompletedHabits &&
            lhs.isEditingHabit == rhs.isEditingHabit &&
            lhs.userName == rhs.userName &&
            lhs.mainReportText == rhs.mainReportText &&
            lhs.isToastVisible == rhs.isToastVisible &&
            lhs.selectedHabit?.id == rhs.selectedHabit?.id
        }
    }
    
    enum Action: BindableAction {
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
        case fetchTodayHabitCount
        case fetchedTodayHabitCount(Int)
        case fetchWeeklyHabitStats
        case fetchedWeeklyHabitStats([Int])
        case fetchMonthSummary
        case fetchedMonthSummary(Int, Int)
        case updateContinuity
        case resetContinuity
        case setAddMode(Bool)
        case setHabitTitle(String)
    }
    
    @Dependency(\.habitClient) var habitClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
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
                
            case let .setAddMode(flag):
                state.isShowingAdd = flag
                return .none
                
            case let .setHabitTitle(title):
                state.habitTitle = title
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
                return .run { _ in try await habitClient.resetContinuityIfNotDone() }
                
                
            }
        }
    }
}
    
