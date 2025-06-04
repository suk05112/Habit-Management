//
//  HabitClient.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import ComposableArchitecture
import Foundation
import RealmSwift

struct HabitClient {
    var fetchAll: @Sendable () async throws -> [Habit]
    var fetchFiltered: @Sendable (Bool, Bool) async throws -> [Habit]
    var save: @Sendable (Habit) async throws -> Void
    var update: @Sendable (Habit, String, [Int]) async throws -> Void
    var delete: @Sendable (Habit) async throws -> Void
    var todayHabitCount: @Sendable () async throws -> Int
    var weeklyHabitStats: @Sendable () async throws -> [Int]
    var monthSummary: @Sendable () async throws -> (Int, Int)
    var updateContinuity: @Sendable () async throws -> Void
    var resetContinuityIfNotDone: @Sendable () async throws -> Void
}

extension HabitClient: DependencyKey {
    static let liveValue = HabitClient(
        fetchAll: {
            let realm = try Realm()
            return Array(realm.objects(Habit.self))
        },

        fetchFiltered: { showAll, hideCompleted in
            let realm = try Realm()
            var list = Array(realm.objects(Habit.self))
            if !showAll {
                let todayWeek = Calendar.current.component(
                    .weekday, from: Date())
                list = list.filter { $0.weekIter.contains(todayWeek) }
            }
            if hideCompleted {
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                let key = fmt.string(from: Date())
                let completedList =
                    realm.object(
                        ofType: CompletedList.self, forPrimaryKey: key)?
                    .completed ?? List<String>()
                let completedIDs = Set(completedList)
                list = list.filter { !completedIDs.contains($0.id!) }
            }
            return list.map { $0.detached() }
        },

        save: { habit in
            let realm = try Realm()
            try realm.write { realm.add(habit, update: .modified) }
        },

        update: { habit, name, iter in
            let realm = try Realm()
            try realm.write {
                habit.name = name
                habit.weekIter.removeAll()
                habit.weekIter.append(objectsIn: iter)
            }
        },

        delete: { habit in
            let realm = try Realm()
            try realm.write { realm.delete(habit) }
        },

        todayHabitCount: {
            let realm = try Realm()
            let todayWeek = Calendar.current.component(.weekday, from: Date())
            return realm.objects(Habit.self).filter {
                $0.weekIter.contains(todayWeek)
            }.count
        },
        weeklyHabitStats: {
            let realm = try Realm()
            var stats = Array(repeating: 0, count: 7)
            realm.objects(Habit.self).forEach { habit in
                for weekday in habit.weekIter {
                    stats[weekday - 1] += 1
                }
            }
            if let stat = realm.objects(Statics.self).filter(
                "classification == 'Todo'"
            ).first {
                try realm.write { stat.dayArray = stats }
            }
            return stats
        },
        monthSummary: {
            let calendar = Calendar(identifier: .gregorian)
            let nextMonth = calendar.date(
                byAdding: .month, value: 1, to: Date())!
            let endOfMonth = calendar.date(
                byAdding: .day, value: -1, to: nextMonth)!
            let endOfLastMonth = calendar.date(
                byAdding: .day, value: -2, to: nextMonth)!
            let thisMonth = calendar.component(.month, from: endOfMonth)
            let lastMonth = calendar.component(.month, from: endOfLastMonth)
            return (thisMonth, lastMonth)
        },
        updateContinuity: {
            let realm = try Realm()
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            let todayKey = fmt.string(from: Date())
            let yesterday = Calendar.current.date(
                byAdding: .day, value: -1, to: Date())!
            let yKey = fmt.string(from: yesterday)
            let completedToday =
                realm.object(
                    ofType: CompletedList.self, forPrimaryKey: todayKey)?
                .completed ?? List<String>()
            let completedYesterday =
                realm.object(ofType: CompletedList.self, forPrimaryKey: yKey)?
                .completed ?? List<String>()

            try realm.write {
                for habit in realm.objects(Habit.self) {
                    if !completedYesterday.contains(habit.id ?? "") {
                        habit.continuity = 0
                    }
                    if completedToday.contains(habit.id ?? "") {
                        habit.continuity += 1
                    }
                }
            }
        },
        resetContinuityIfNotDone: {
            let realm = try Realm()
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            let yesterday = Calendar.current.date(
                byAdding: .day, value: -1, to: Date())!
            let yKey = fmt.string(from: yesterday)
            try realm.write {
                for habit in realm.objects(Habit.self) {
                    let completedYesterday =
                        realm.object(
                            ofType: CompletedList.self, forPrimaryKey: yKey)?
                        .completed ?? List<String>()
                    if !completedYesterday.contains(habit.id ?? "") {
                        habit.continuity = 0
                    }
                }
            }
        }
    )
}
