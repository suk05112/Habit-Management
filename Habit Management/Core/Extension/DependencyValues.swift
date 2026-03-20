//
//  DependencyValues.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import ComposableArchitecture

struct UserDefaultsClient {
    var integerForKey: @Sendable (String) -> Int
    var setInteger: @Sendable (Int, String) -> Void
}

extension UserDefaultsClient: DependencyKey {
    static let liveValue = UserDefaultsClient(
        integerForKey: { key in
            UserDefaults.standard.integer(forKey: key)
        },
        setInteger: { value, key in
            UserDefaults.standard.set(value, forKey: key)
        }
    )
}

extension DependencyValues {
    var habitClient: HabitClient {
        get { self[HabitClient.self] }
        set { self[HabitClient.self] = newValue }
    }
    
    var completionClient: CompletionClient {
        get { self[CompletionClient.self] }
        set { self[CompletionClient.self] = newValue }
    }

    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }

    var reportClient: ReportClient {
        get { self[ReportClient.self] }
        set { self[ReportClient.self] = newValue }
    }

}
