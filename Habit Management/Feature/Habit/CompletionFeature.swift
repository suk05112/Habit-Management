//
//  CompletionFeature.swift
//  Habit Management
//
//  Created by 남경민 on 5/28/25.
//

import Foundation
import ComposableArchitecture

struct CompletionFeature: Reducer {
    struct State: Equatable {
        var doneTodayMap: [String: Bool] = [:]
        var todayCount: Int = 0
        var yesterdayCount: Int = 0
        var staticsCount: Int = 0
    }

    enum Action: Equatable {
        case toggle(String)
        case toggleResponse(Bool)
        case loadDoneToday(String)
        case doneTodayResponse(String, Bool)
        case loadTodayCount
        case loadYesterdayCount
        case todayCountResponse(Int)
        case yesterdayCountResponse(Int)
        case loadStatics(Total)
        case staticsResponse(Int)
    }

    @Dependency(\.completionClient) var completionClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
            return .none

        case let .yesterdayCountResponse(count):
            state.yesterdayCount = count
            return .none

        case let .loadStatics(total):
            return .run { send in
                let count = try await completionClient.statics(total)
                await send(.staticsResponse(count))
            }

        case let .staticsResponse(count):
            state.staticsCount = count
            return .none
        }
    }
}
