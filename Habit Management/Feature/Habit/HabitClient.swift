//
//  HabitClient.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import ComposableArchitecture
import RealmSwift

struct HabitClient {
    var fetchAll: @Sendable () async throws -> [Habit]
    var fetchFiltered: @Sendable (Bool, Bool) async throws -> [Habit]
    var save: @Sendable (Habit) async throws -> Void
    var update: @Sendable (Habit, String, [Int]) async throws -> Void
    var delete: @Sendable (Habit) async throws -> Void
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
                let todayWeek = Calendar.current.component(.weekday, from: Date())
                list = list.filter { $0.weekIter.contains(todayWeek) }
            }
            if hideCompleted {
                let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
                let key = fmt.string(from: Date())
                let completedList = realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed ?? List<String>()
                let completedIDs = Set(completedList)
                list = list.filter { !completedIDs.contains($0.id!) }
            }
            return list
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
        }
    )
}
