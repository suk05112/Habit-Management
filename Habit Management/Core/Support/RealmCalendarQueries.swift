//
//  RealmCalendarQueries.swift
//  Habit Management
//
//  CompletedListViewModel / HabitViewModel 없이 달력·요일별 예정 습관 수 조회
//

import Foundation
import RealmSwift

enum RealmCalendarQueries {
    /// 요일(1…7)별로 그날 예정된 습관 개수. Realm 한 번 순회.
    static func habitsScheduledCountByWeekday() -> [Int: Int] {
        guard let realm = try? Realm() else {
            return Dictionary(uniqueKeysWithValues: (1...7).map { ($0, 0) })
        }
        var counts = [Int: Int](uniqueKeysWithValues: (1...7).map { ($0, 0) })
        for habit in realm.objects(Habit.self) {
            for w in habit.weekIter where (1...7).contains(w) {
                counts[w, default: 0] += 1
            }
        }
        return counts
    }

    /// 날짜 문자열(yyyy-MM-dd)별 그날 완료 기록 개수. 날짜당 primary key 조회만 (전체 스캔 없음).
    static func completionCounts(for dates: [String]) -> [String: Int] {
        guard let realm = try? Realm() else { return [:] }
        let unique = Array(Set(dates.filter { !$0.isEmpty }))
        var result: [String: Int] = [:]
        result.reserveCapacity(unique.count)
        for date in unique {
            result[date] = realm.object(ofType: CompletedList.self, forPrimaryKey: date)?.completed.count ?? 0
        }
        return result
    }

    /// 특정 요일에 예정된 습관 수 (Week.total 등 단발 조회용).
    static func habitsScheduledCount(on weekday: Int) -> Int {
        guard (1...7).contains(weekday), let realm = try? Realm() else { return 0 }
        return realm.objects(Habit.self).filter { $0.weekIter.contains(weekday) }.count
    }
}
