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
    var fetchAll: @Sendable () async throws -> [HabitModel]
    var fetchFiltered: @Sendable (Bool, Bool) async throws -> [HabitModel]
    var save: @Sendable (HabitModel) async throws -> Void
    var update: @Sendable (HabitModel, String, [Int]) async throws -> Void
    var delete: @Sendable (HabitModel) async throws -> Void
    var todayHabitCount: @Sendable () async throws -> Int
    var weeklyHabitStats: @Sendable () async throws -> [Int]
    var monthSummary: @Sendable () async throws -> (Int, Int)
    var updateContinuity: @Sendable () async throws -> Void
    var resetContinuityIfNotDone: @Sendable () async throws -> Void
}

extension HabitClient: DependencyKey {
    static let liveValue: HabitClient = {
        let realmManager = RealmManager<Habit>(configuration: nil, fileUrl: nil)
        let completionManager = RealmManager<CompletedList>(configuration: nil, fileUrl: nil)
        let statisticsManager = RealmManager<Statistics>(configuration: nil, fileUrl: nil)

        let habitRepository = RealmHabitRepository(realmManager: realmManager)
        let completionRepository = RealmCompletionRepository(realmManager: completionManager)
        let statisticsRepository = RealmStatisticsRepository(realmManager: statisticsManager)

        return HabitClient(
            fetchAll: {
                return try await habitRepository.findAll()
            },

            fetchFiltered: { showAll, hideCompleted in
                let today = DateFormatters.standard.string(from: Date())
                let todayWeekDay = Date().weekday

                var habits = try await habitRepository.findAll()

                if !showAll {
                    habits = habits.filter { $0.weekIter.contains(todayWeekDay) }
                }

                if hideCompleted {
                    if let completedToday = try await completionRepository.read(date: today) {
                        let completedIDs = Set(completedToday.completed)
                        habits = habits.filter { !completedIDs.contains($0.id) }
                    }
                }

                return habits
            },

            save: { habit in
                try await habitRepository.create(habit)
            },

            update: { habit, name, iter in
                let updatedHabit = HabitModel(
                    id: habit.id,
                    name: name,
                    weekIter: iter,
                    continuity: habit.continuity
                )
                try await habitRepository.update(updatedHabit)
            },

            delete: { habit in
                try await habitRepository.delete(id: habit.id)
            },

            todayHabitCount: {
                let todayWeekDay = Date().weekday
                let habits = try await habitRepository.findAll()
                return habits.filter { $0.weekIter.contains(todayWeekDay) }.count
            },

            weeklyHabitStats: {
                let habits = try await habitRepository.findAll()
                var stats = Array(repeating: 0, count: 7)
                habits.forEach { habit in
                    for weekday in habit.weekIter {
                        stats[weekday - 1] += 1
                    }
                }

                let year = Calendar.current.component(.year, from: Date())
                if let existingStats = try await statisticsRepository.read(
                    classification: "Todo", year: year)
                {
                    let updatedStats = StatisticsModel(
                        year: year,
                        days: stats,
                        week: existingStats.week,
                        month: existingStats.month,
                        total: existingStats.total,
                        classification: "Todo"
                    )
                    try await statisticsRepository.update(updatedStats)
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
                let todayKey = DateFormatters.standard.string(from: Date())
                let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))

                let completedToday = try await completionRepository.read(date: todayKey)
                let completedYesterday = try await completionRepository.read(date: yesterdayKey)

                let todayCompletedIDs = Set(completedToday?.completed ?? [])
                let yesterdayCompletedIDs = Set(completedYesterday?.completed ?? [])

                let habits = try await habitRepository.findAll()

                for habit in habits {
                    var newContinuity = habit.continuity

                    if !yesterdayCompletedIDs.contains(habit.id) {
                        newContinuity = 0
                    }
                    if todayCompletedIDs.contains(habit.id) {
                        newContinuity += 1
                    }

                    if newContinuity != habit.continuity {
                        let updatedHabit = HabitModel(
                            id: habit.id,
                            name: habit.name,
                            weekIter: habit.weekIter,
                            continuity: newContinuity
                        )
                        try await habitRepository.update(updatedHabit)
                    }
                }
            },

            resetContinuityIfNotDone: {
                let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))
                let completedYesterday = try await completionRepository.read(date: yesterdayKey)
                let yesterdayCompletedIDs = Set(completedYesterday?.completed ?? [])

                let habits = try await habitRepository.findAll()

                for habit in habits {
                    if !yesterdayCompletedIDs.contains(habit.id) && habit.continuity > 0 {
                        let updatedHabit = HabitModel(
                            id: habit.id,
                            name: habit.name,
                            weekIter: habit.weekIter,
                            continuity: 0
                        )
                        try await habitRepository.update(updatedHabit)
                    }
                }
            }
        )
    }()
}
