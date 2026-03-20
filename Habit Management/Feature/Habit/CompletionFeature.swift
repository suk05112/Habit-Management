//
//  CompletionFeature.swift
//  Habit Management
//
//  Created by 남경민 on 5/28/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CompletionFeature {
    struct State: Equatable {
        var doneTodayMap: [String: Bool] = [:]
        var todayCount: Int = 0
        var yesterdayCount: Int = 0
        var statisticsCount: Int = 0
        var continuityCount: Int = 0
        var dateCount: Int = 0
        var refreshTick: Int = 0
    }

    enum Action: BindableAction {
        case toggle(String)
        case toggleResponse(Bool)
        case loadDoneToday(String)
        case doneTodayResponse(String, Bool)
        case loadTodayCount
        case loadYesterdayCount
        case todayCountResponse(Int)
        case yesterdayCountResponse(Int)
        case loadStatistics(Total)
        case statisticsResponse(Int)
        case updateAllDoneContinuity(CompleteStatus, Bool)
        case continuityUpdated(Int)
        case loadDateCount(String)
        case dateCount(Int)
        case refreshCalendar
        case binding(BindingAction<State>)
    }

    @Dependency(\.completionClient) var completionClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case let .toggle(id):
                return .run { send in
                    do {
                        try await completionClient.toggle(id)
                        await send(.toggleResponse(true))
                    } catch {
                        await send(.toggleResponse(false))
                    }
                }
                
            case .toggleResponse:
                return .none
                
            case let .loadDoneToday(id):
                return .run { send in
                    let result = try await completionClient.isDoneToday(id)
                    await send(.doneTodayResponse(id, result))
                }
                
            case let .doneTodayResponse(id, result):
                state.doneTodayMap[id] = result
                return .none
                
            case .loadTodayCount:
                print("loadTodayCount 호출")
                return .run { send in
                    let count = try await completionClient.todayHabitCompleteCount()
                    await send(.todayCountResponse(count))
                }
                
            case .loadYesterdayCount:
                return .run { send in
                    let count = try await completionClient.yesterdayHabitCompleteCount()
                    await send(.yesterdayCountResponse(count))
                }
                
            case let .todayCountResponse(count):
                state.todayCount = count
                print("todayCountResponse todayCount", state.todayCount )
                return .none
                
            case let .yesterdayCountResponse(count):
                state.yesterdayCount = count
                return .none
                
            case let .loadStatistics(total):
                return .run { send in
                    let count = try await completionClient.statistics(total)
                    await send(.statisticsResponse(count))
                }
                
            case let .statisticsResponse(count):
                state.statisticsCount = count
                return .none
                
            case let .updateAllDoneContinuity(status, isToday):
                let key = "allDoneContinuity"
                guard isToday else {
                    return .send(.continuityUpdated(userDefaultsClient.integerForKey(key)))
                }

                var continuity = userDefaultsClient.integerForKey(key)
                continuity = max(continuity, 0)

                if status == .complete {
                    continuity += 1
                } else if status == .cancel || status == .add {
                    continuity = max(continuity - 1, 0)
                }

                userDefaultsClient.setInteger(continuity, key)
                return .send(.continuityUpdated(continuity))

            case let .continuityUpdated(newCount):
                state.continuityCount = newCount
                return .none
                
            case let .loadDateCount(date):
                return .run { send in
                    let count = try await completionClient.countForDate(date)
                    await send(.dateCount(count))
                }
            
            case let .dateCount(count):
                state.dateCount = count
                return .none

            case .refreshCalendar:
                state.refreshTick += 1
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
