//
//  HabitToggleFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/15/25.
//

import Foundation
import ComposableArchitecture

// MARK: - TODO: isShowAll, isHideCompleted 내부저장소로 관리
// MARK: - TODO: UserDefaults 다 묶어서 UserDefaultsClient로 만들기

@Reducer
struct HabitToggleFeature {
    struct State: Equatable {
        var isShowAll: Bool = false
        var isHideCompleted: Bool = false
        var labelTitle: LabelTitle = LabelTitle()
        var selectedHabit: Habit?
    }
    
    enum Action: Equatable {
        case onAppear
        case showAllButtonPressed
        case hideCompletedButtonPressed
        case addHabitButtonPressed
        //        case selectItem(Habit?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.labelTitle = LabelTitle()
                return .none
                
            case .showAllButtonPressed:
                state.isShowAll.toggle()
                state.labelTitle.showAll = state.isShowAll ? L10n.tr("toggle.show_all_habits") : L10n.tr("toggle.today_habits")
                return .none
                
            case .hideCompletedButtonPressed:
                state.isHideCompleted.toggle()
                state.labelTitle.hideCompleted = state.isHideCompleted ? L10n.tr("toggle.hide_completed") : L10n.tr("toggle.show_completed")
                return .none
                
            case .addHabitButtonPressed:
                print("🧊")
                return .none
            }
        }
    }
}

// MARK: - Structure Model
extension HabitToggleFeature {
    struct LabelTitle: Identifiable, Equatable {
        let id = UUID()
        var showAll: String = L10n.tr("toggle.today_habits")
        var hideCompleted: String = L10n.tr("toggle.show_completed")
    }
}
