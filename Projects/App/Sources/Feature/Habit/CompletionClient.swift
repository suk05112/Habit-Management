//
//  CompletionClient.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import ComposableArchitecture
import Foundation
import RealmSwift

struct CompletionClient {
    var toggle: @Sendable (String) async throws -> Void
    var deleteListForDate: @Sendable (String) async throws -> Void
    var countForDate: @Sendable (String) async throws -> Int
    var statistics: @Sendable (Total) async throws -> Int
    var isDoneToday: @Sendable (String) async throws -> Bool
    var todayHabitCompleteCount: @Sendable () async throws -> Int
    var yesterdayHabitCompleteCount: @Sendable () async throws -> Int
    var updateAllDoneContinuity: @Sendable (CompleteStatus, Bool) async throws -> Int
}

extension CompletionClient: DependencyKey {
    static let liveValue: CompletionClient = {
        let completionManager = RealmManager<CompletedList>(configuration: nil, fileUrl: nil)
        let habitManager = RealmManager<Habit>(configuration: nil, fileUrl: nil)

        let completionRepository = RealmCompletionRepository(realmManager: completionManager)
        let habitRepository = RealmHabitRepository(realmManager: habitManager)

        return CompletionClient(
            toggle: { id in
                let todayKey = DateFormatters.standard.string(from: Date())

                if let existingCompletion = try await completionRepository.read(date: todayKey) {
                    let updatedCompletion: CompletionModel
                    if existingCompletion.completed.contains(id) {
                        updatedCompletion = existingCompletion.removingCompletion(habitId: id)
                    } else {
                        updatedCompletion = existingCompletion.addingCompletion(habitId: id)
                    }
                    try await completionRepository.update(updatedCompletion)
                } else {
                    let newCompletion = CompletionModel(date: todayKey, completed: [id])
                    try await completionRepository.create(newCompletion)
                }

                // Update habit continuity
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

            deleteListForDate: { date in
                try await completionRepository.delete(date: date)
            },

            countForDate: { date in
                if let completion = try await completionRepository.read(date: date) {
                    return completion.completed.count
                }
                return 0
            },

            statistics: { staticCase in
                let comps = Calendar.current.dateComponents(
                    [.year, .month, .weekday], from: Date())
                let year = comps.year!
                let month = comps.month!
                let weekday = comps.weekday!
                var ans = 0
                let all = try await completionRepository.findAll()

                switch staticCase {
                case .week:
                    let ago = Calendar.current.date(byAdding: .day, value: -weekday, to: Date())!
                    let key = DateFormatters.standard.string(from: ago)
                    for item in all.reversed() {
                        if item.date > key { ans += item.completed.count } else { break }
                    }
                case .month:
                    for item in all {
                        if Int(item.date.split(separator: "-")[1]) == month {
                            ans += item.completed.count
                        }
                    }
                case .year:
                    for item in all {
                        if Int(item.date.prefix(4)) == year { ans += item.completed.count }
                    }
                case .all:
                    for item in all { ans += item.completed.count }
                }
                return ans
            },

            isDoneToday: { id in
                let key = DateFormatters.standard.string(from: Date())
                if let completion = try await completionRepository.read(date: key) {
                    return completion.completed.contains(id)
                }
                return false
            },

            todayHabitCompleteCount: {
                let todayWeek = Date().weekday
                let habits = try await habitRepository.findAll()
                let todayHabits = habits.filter { $0.weekIter.contains(todayWeek) }

                let key = DateFormatters.standard.string(from: Date())
                let completed = try await completionRepository.read(date: key)
                let completedIDs = Set(completed?.completed ?? [])

                return todayHabits.filter { completedIDs.contains($0.id) }.count
            },

            yesterdayHabitCompleteCount: {
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                let key = DateFormatters.standard.string(from: yesterday)
                if let completion = try await completionRepository.read(date: key) {
                    return completion.completed.count
                }
                return 0
            },

            updateAllDoneContinuity: { status, isToday in
                guard isToday else {
                    return UserDefaults.standard.integer(forKey: "allDoneContinuity")
                }

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
    }()
}
