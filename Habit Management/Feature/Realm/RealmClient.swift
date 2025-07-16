//
//  RealmClient.swift
//  Habit Management
//
//  Created by 남경민 on 7/16/25.
//

import Foundation
import RealmSwift
import ComposableArchitecture

@DBActor
final class RealmClient: RealmService, @unchecked Sendable {
    
    private var realm: Realm!
    
    nonisolated init() { }

    func initRealm() async throws {
        self.realm = try await Realm(actor: DBActor.shared)
    }
    
    func addHabit(_ habit: Habit) {
        try? realm.write {
            realm.add(habit, update: .modified)
        }
    }
    
    func updateHabit(_ habit: Habit, name: String, iter: [Int]) {
        try? realm.write {
            habit.name = name
            habit.weekIter.removeAll()
            habit.weekIter.append(objectsIn: iter)
        }
    }

    func deleteHabit(_ habit: Habit) {
        try? realm.write {
            realm.delete(habit)
        }
    }

    func fetchAllHabits() -> [Habit] {
        return Array(realm.objects(Habit.self))
    }

    func fetchFilteredHabits(showAll: Bool, hideCompleted: Bool) -> [Habit] {
        let today = DateFormatters.standard.string(from: Date())
        let todayWeekDay = Date().weekday
        
        var query = realm.objects(Habit.self)
        
        if !showAll {
            query = query.where { $0.weekIter.contains(todayWeekDay) }
        }
        
        if hideCompleted {
            if let completedList = realm.object(ofType: CompletedList.self, forPrimaryKey: today)?.completed {
                let completedIDs = Set(completedList)
                query = query.where { !$0.id.in(completedIDs) }
            }
        }

        return Array(query)
    }

    func countTodayHabit() -> Int {
        let todayWeekDay = Date().weekday
        return realm.objects(Habit.self).filter {
            $0.weekIter.contains(todayWeekDay)
        }.count
    }

    func weeklySummary() -> [Int] {
        var stats = Array(repeating: 0, count: 7)
        realm.objects(Habit.self).forEach { habit in
            for weekday in habit.weekIter {
                stats[weekday - 1] += 1
            }
        }
        if let stat = realm.objects(Statistics.self).filter("classification == 'Todo'").first {
            try? realm.write {
                stat.dayArray = stats
            }
        }
        return stats
    }

    func monthSummary() -> (Int, Int) {
        let calendar = Calendar(identifier: .gregorian)
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: Date())!
        let endOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        let endOfLastMonth = calendar.date(byAdding: .day, value: -2, to: nextMonth)!
        let thisMonth = calendar.component(.month, from: endOfMonth)
        let lastMonth = calendar.component(.month, from: endOfLastMonth)
        return (thisMonth, lastMonth)
    }

    func updateContinuity() {
        let todayKey = DateFormatters.standard.string(from: Date())
        let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))
        
        let completedToday = realm.object(ofType: CompletedList.self, forPrimaryKey: todayKey)?.completed ?? List<String>()
        let completedYesterday = realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?.completed ?? List<String>()
        
        try? realm.write {
            for habit in realm.objects(Habit.self) {
                if !completedYesterday.contains(habit.id ?? "") {
                    habit.continuity = 0
                }
                if completedToday.contains(habit.id ?? "") {
                    habit.continuity += 1
                }
            }
        }
    }

    func resetContinuity() {
        let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))
        try? realm.write {
            for habit in realm.objects(Habit.self) {
                let completedYesterday = realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?.completed ?? List<String>()
                if !completedYesterday.contains(habit.id ?? "") {
                    habit.continuity = 0
                }
            }
        }
    }

    func toggleCompleted(id: String) {
        let todayKey = DateFormatters.standard.string(from: Date())
        
        try? realm.write {
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
        try? realm.write {
            let yesterday = Date().adding(-1)
            let yesterdayKey = DateFormatters.standard.string(from: yesterday)
            let yList = realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?.completed ?? List<String>()
            for habit in realm.objects(Habit.self) {
                if !yList.contains(habit.id!) { habit.continuity = 0 }
                if completedSet.contains(habit.id!) { habit.continuity += 1 }
            }
        }
    }

    func deleteCompletedList(for date: String) {
        if let obj = realm.object(ofType: CompletedList.self, forPrimaryKey: date) {
            try? realm.write {
                realm.delete(obj)
            }
        }
    }

    func countCompletedList(for date: String) -> Int {
        return realm.object(ofType: CompletedList.self, forPrimaryKey: date)?.completed.count ?? 0
    }

    func isDoneToday(id: String) -> Bool {
        let key = DateFormatters.standard.string(from: Date())
        return realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed.contains(id) == true
    }

    func countCompletedTodayHabit() -> Int {
        let todayWeek = Date().weekday
        let todos = realm.objects(Habit.self).filter { $0.weekIter.contains(todayWeek) }
        let key = DateFormatters.standard.string(from: Date())
        let completed = realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed ?? List<String>()
        let completedIDs = Set(completed)
        return todos.filter { completedIDs.contains($0.id!) }.count
    }

    func countCompletedYesterdayHabit() -> Int {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let key = DateFormatters.standard.string(from: Date())
        return realm.object(ofType: CompletedList.self, forPrimaryKey: key)?.completed.count ?? 0
    }

    func getContinuity(status: CompleteStatus, isToday: Bool) -> Int {
        let key = "allDoneContinuity"
        guard isToday else {
            return UserDefaults.standard.integer(forKey: key)
        }
        
        var continuity = UserDefaults.standard.integer(forKey: key)
        if continuity < 0 { continuity = 0 }
        
        switch status {
        case .complete:
            continuity += 1
        case .cancel, .add:
            continuity = max(continuity - 1, 0)
        case .delete:
            print("delete")
        }
        
        UserDefaults.standard.set(continuity, forKey: key)
        return continuity
    }
    
}

enum RealmClientKey: DependencyKey {
    static let liveValue: RealmService = RealmClient()
}
