//
//  MainFeature.swift
//  Habit Management
//
//  Created by 남경민 on 5/21/25.
//

import ComposableArchitecture
import Foundation
import RealmSwift

struct MainFeature: Reducer {
    struct State: Equatable {
        var habits: [Habit] = []
        var showAll: Bool = true
        var hideCompleted: Bool = false
        var selectedItem: Habit? = nil
        var showToast: Bool = false
        var isEdit: Bool = false
        var userName: String = ""
        var mainReport: String = ""
    }

    enum Action: Equatable {
        case onAppear
        case loadHabits
        case setHabits([Habit])
        case toggleShowAll
        case toggleHideCompleted
        case setUserName(String)
        case setMainReport(String)
        case setToast(Bool)
        case selectItem(Habit?)
        case setEditMode(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.loadHabits),
                    .send(.setUserName(UserDefaults.standard.string(forKey: "userName") ?? "사용자")),
                    .send(.setMainReport(ReportData.shared.getMainReport()))
                )

            case .loadHabits:
                let realm = try! Realm()
                let all = realm.objects(Habit.self).map { $0 }
                state.habits = Array(all)
                return .none

            case .setHabits(let habits):
                state.habits = habits
                return .none

            case .toggleShowAll:
                state.showAll.toggle()
                return .none

            case .toggleHideCompleted:
                state.hideCompleted.toggle()
                return .none

            case .setUserName(let name):
                state.userName = name
                return .none

            case .setMainReport(let report):
                state.mainReport = report
                return .none

            case .setToast(let flag):
                state.showToast = flag
                return .none

            case .selectItem(let habit):
                state.selectedItem = habit
                return .none

            case .setEditMode(let flag):
                state.isEdit = flag
                return .none
            }
        }
    }
}
