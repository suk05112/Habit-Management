//
//  CompletionClient.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import ComposableArchitecture
import RealmSwift

struct CompletionClient {
    var toggle: @Sendable (String) async throws -> Void
    var deleteListForDate: @Sendable (String) async throws -> Void
    var countForDate: @Sendable (String) async throws -> Int
    var statics: @Sendable (Total) async throws -> Int
    var isDoneToday: @Sendable (String) async throws -> Bool
    var todayHabitCompleteCount: @Sendable () async throws -> Int
    var yesterdayHabitCompleteCount: @Sendable () async throws -> Int
    var updateAllDoneContinuity: @Sendable (CompleteStatus, Bool) async throws -> Int
}

extension CompletionClient: DependencyKey {
    static let liveValue = CompletionClient(
        toggle: { id in
            let realm = try Realm()
            let todayKey = DateFormatters.standard.string(from: Date())

            try realm.write {
                if let list = realm.object(ofType: CompletedList.self, forPrimaryKey: todayKey) {
                    if let idx = list.completed.firstIndex(of: id) {
                        list.completed.remove(at: idx)
                    } else {
                        list.completed.append(id)
                    }
                } else {
                    let new = CompletedList(today: todayKey, iter: [id])
                    realm.add(new)
                }
            }
            
            let completedSet = realm.object(ofType: CompletedList.self, forPrimaryKey: todayKey)!.completed
            try realm.write {
                let yesterday = Date().adding(-1)
                let yesterdayKey = DateFormatters.standard.string(from: yesterday)
                let yList = realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?.completed ?? List<String>()
                for habit in realm.objects(Habit.self) {
                    if !yList.contains(habit.id!) { habit.continuity = 0 }
                    if completedSet.contains(habit.id!) { habit.continuity += 1 }
                }
            }
        },
        
        deleteListForDate: { date in
            let realm = try Realm()
            if let obj = realm.object(ofType: CompletedList.self, forPrimaryKey: date) {
                try realm.write { realm.delete(obj) }
            }
        },
        
        countForDate: { date in
            let realm = try Realm()
            return realm.object(ofType: CompletedList.self, forPrimaryKey: date)?.completed.count ?? 0
        },
        
        statics: { staticCase in
            let realm = try Realm()
            let comps = Calendar.current.dateComponents([.year, .month, .weekday], from: Date())
            let year = comps.year!, month = comps.month!, weekday = comps.weekday!
            var ans = 0
            let all = realm.objects(CompletedList.self)
            switch staticCase {
            case .week:
                let ago = Calendar.current.date(byAdding: .day, value: -weekday, to: Date())!
                let key = DateFormatters.standard.string(from: ago)
                for item in all.reversed() {
                    if item.date > key { ans += item.completed.count } else { break }
                }
            case .month:
                for item in all {
                    if Int(item.date.split(separator: "-")[1]) == month { ans += item.completed.count }
                }
            case .year:
                for item in all { if Int(item.date.prefix(4)) == year { ans += item.completed.count } }
            case .all:
                for item in all { ans += item.completed.count }
            }
            return ans
        },
        
        isDoneToday: { id in
            let realm = try Realm()
            let key = DateFormatters.standard.string(from: Date())
            return realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed.contains(id) == true
        },
        
        todayHabitCompleteCount: {
            let realm = try Realm()
            let todayWeek = Date().weekday
            let todos = realm.objects(Habit.self).filter { $0.weekIter.contains(todayWeek) }
            let key = DateFormatters.standard.string(from: Date())
            let completed = realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed ?? List<String>()
            let completedIDs = Set(completed)
            return todos.filter { completedIDs.contains($0.id!) }.count
        },
        
        yesterdayHabitCompleteCount: {
            let realm = try Realm()
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            let key = DateFormatters.standard.string(from: Date())
            return realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed.count ?? 0
        },
        
        updateAllDoneContinuity: { status, isToday in
            guard isToday else { return UserDefaults.standard.integer(forKey: "allDoneContinuity") }

            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: Date())
            let key = "allDoneContinuity"
            var continuity = UserDefaults.standard.integer(forKey: key)

            if continuity < 0 { continuity = 0 }

            if status == .complete {
                continuity += 1
            } else if status == .cancel || status == .add {
                continuity = max(continuity - 1, 0)
            }

            UserDefaults.standard.set(continuity, forKey: key)
            return continuity
        }
    )
}
