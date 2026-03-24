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
    /// 홈 상단 인사 아래 연속 달성 문구 (`ReportData.getMainReportText`와 동일 로직)
    var mainHeaderReportText: @Sendable () -> String
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
        },
        mainHeaderReportText: {
            var list: [(String, String)] = []
            let realm = try? Realm()
            let habits = realm?.objects(Habit.self).map {
                (continuity: $0.continuity, name: $0.name)
            } ?? []
            guard !habits.isEmpty else {
                return L10n.tr("habit.header.empty")
            }
            for h in habits where h.continuity > 0 && !h.name.isEmpty {
                list.append((String(h.continuity), h.name))
            }
            guard !list.isEmpty else {
                return L10n.tr("habit.header.empty")
            }
            let item = list[Int.random(in: 0..<list.count)]
            let days = Int(item.0) ?? 0
            return L10n.tr("report.main_streak", days, item.1)
        }
    )
}
