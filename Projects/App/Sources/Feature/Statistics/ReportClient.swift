//
//  ReportClient.swift
//  Habit Management
//
//  Created by Cursor on 3/14/26.
//

import ComposableArchitecture
import RealmSwift
import Foundation

struct ReportClient {
    var todayHabitCount: @Sendable () -> Int
    var todayHabits: @Sendable () -> [Habit]
    var todayCompletedIDs: @Sendable () -> Set<String>
    var hasHabitAndCompletionData: @Sendable () -> Bool
    var habitsWithContinuity: @Sendable () -> [(continuity: Int, name: String)]
}

extension ReportClient: DependencyKey {
    static let liveValue = ReportClient(
        todayHabitCount: {
            let realm = try? Realm()
            let todayWeekDay = Date().weekday
            return realm?.objects(Habit.self).filter {
                $0.weekIter.contains(todayWeekDay)
            }.count ?? 0
        },
        todayHabits: {
            let realm = try? Realm()
            let todayWeekDay = Date().weekday
            return realm?.objects(Habit.self).filter {
                $0.weekIter.contains(todayWeekDay)
            }.map { $0.detached() } ?? []
        },
        todayCompletedIDs: {
            let realm = try? Realm()
            let key = DateFormatters.standard.string(from: Date())
            let completed = realm?.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed ?? List<String>()
            return Set(completed)
        },
        hasHabitAndCompletionData: {
            let realm = try? Realm()
            guard
                let firstHabit = realm?.objects(Habit.self).first,
                let lastCompleted = realm?.objects(CompletedList.self).last
            else { return false }
            return firstHabit.id != nil && !lastCompleted.completed.isEmpty
        },
        habitsWithContinuity: {
            let realm = try? Realm()
            return realm?.objects(Habit.self).map {
                (continuity: $0.continuity, name: $0.name)
            } ?? []
        }
    )
}
