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
    /// 해당 id 순서대로 sortOrder를 0…n-1로 일괄 반영 (한 번의 write)
    var applySortOrder: @Sendable ([String]) async throws -> Void
    var todayHabitCount: @Sendable () async throws -> Int
    var weeklyHabitStats: @Sendable () async throws -> [Int]
    var monthSummary: @Sendable () async throws -> (Int, Int)
    var updateContinuity: @Sendable () async throws -> Void
    var resetContinuity: @Sendable () async throws -> Void
}

extension HabitClient: DependencyKey {
    static let liveValue = HabitClient(
        fetchAll: {
            let realm = try Realm()
            return Array(realm.objects(Habit.self))
        },
        
        fetchFiltered: { showAll, hideCompleted in
            let realm = try Realm()
            let today = DateFormatters.standard.string(from: Date())
            let todayWeekDay = Date().weekday

            var query: Results<Habit> = realm.objects(Habit.self)

            // 토글 `isShowAll`: false면 오늘 요일에 해당하는 습관만, true면 전체 (라벨과 동일)
            // `filter { }` 클로저는 Swift Sequence용이라 LazyFilterSequence가 되어 Results에 못 넣음 → NSPredicate 사용
            if !showAll {
                query = query.filter(NSPredicate(format: "ANY weekIter == %d", todayWeekDay))
            }

            if hideCompleted {
                if let completedList = realm.object(ofType: CompletedList.self, forPrimaryKey: today)?.completed {
                    let completedIDs = Set(completedList)
                    query = query.where { !$0.id.in(completedIDs) }
                }
            }

            var habits = Array(query).map { $0.detached() }
            habits.sort { Self.compareBySortOrderThenId($0, $1) }

            return habits
        },
        
        save: { habit in
            let realm = try Realm()
            try realm.write {
                // 신규 습관이면 맨 뒤 순번 부여 (기존 행은 sortOrder 유지)
                if habit.id.flatMap({ realm.object(ofType: Habit.self, forPrimaryKey: $0) }) == nil {
                    let maxOrder = realm.objects(Habit.self).max(ofProperty: "sortOrder") as Int? ?? -1
                    habit.sortOrder = maxOrder + 1
                }
                realm.add(habit, update: .modified)
            }
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
            guard let id = habit.id else { return }

            let predicate = NSPredicate(format: "id == %@", id)
            
            if let habitToDelete = realm.objects(Habit.self).filter(predicate).first {
                try realm.write {
                    realm.delete(habitToDelete)
                }
            }
        },
        
        applySortOrder: { orderedIDs in
            let realm = try Realm()
            try realm.write {
                for (index, id) in orderedIDs.enumerated() {
                    realm.object(ofType: Habit.self, forPrimaryKey: id)?.sortOrder = index
                }
            }
        },
        
        todayHabitCount: {
            let realm = try Realm()
            let todayWeekDay = Date().weekday
            return realm.objects(Habit.self)
                .filter("ANY weekIter == %@", todayWeekDay)
                .count
        },
        weeklyHabitStats: {
            let realm = try Realm()
            var stats = Array(repeating: 0, count: 7)
            realm.objects(Habit.self).forEach { habit in
                for weekday in habit.weekIter {
                    stats[weekday - 1] += 1
                }
            }
            if let stat = realm.objects(Statistics.self).filter(
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
            let todayKey = DateFormatters.standard.string(from: Date())
            let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))
            
            let completedToday =
            realm.object(
                ofType: CompletedList.self, forPrimaryKey: todayKey)?
                .completed ?? List<String>()
            let completedYesterday =
            realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?
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
        resetContinuity: {
            let realm = try Realm()
            let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))
            
            try realm.write {
                for habit in realm.objects(Habit.self) {
                    let completedYesterday =
                    realm.object(
                        ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?
                        .completed ?? List<String>()
                    if !completedYesterday.contains(habit.id ?? "") {
                        habit.continuity = 0
                    }
                }
            }
        }
    )
}

private extension HabitClient {
    /// 같은 우선순위(예: 둘 다 오늘 할 일) 안에서의 순서
    static func compareBySortOrderThenId(_ lhs: Habit, _ rhs: Habit) -> Bool {
        if lhs.sortOrder != rhs.sortOrder { return lhs.sortOrder < rhs.sortOrder }
        return (lhs.id ?? "") < (rhs.id ?? "")
    }
}
