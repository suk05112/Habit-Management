//
//  DependencyValues.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var habitClient: HabitClient {
        get { self[HabitClient.self] }
        set { self[HabitClient.self] = newValue }
    }
    
    var completionClient: CompletionClient {
        get { self[CompletionClient.self] }
        set { self[CompletionClient.self] = newValue }
    }
    
}
