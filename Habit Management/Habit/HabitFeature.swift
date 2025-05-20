//
//  HabitAction.swift
//  Habit Management
//
//  Created by 한수진 on 5/20/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HabitFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
  
    enum Action {
        case fetchItem
        case addItem
        case deleteItem
        case updateItem
        case toggleHideCompleted
        case toggleShowAll
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .fetchItem:
                    return .none
                case .addItem:
                    return .none
                case .deleteItem:
                    return .none
                case .updateItem:
                    return .none
                case .toggleHideCompleted:
                    return .none
                case .toggleShowAll:
                    return .none
            }
        }
    }
}



