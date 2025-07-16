//
//  RealmService.swift
//  Habit Management
//
//  Created by 남경민 on 7/16/25.
//

import Foundation

@DBActor
protocol RealmService {
    func initRealm() async throws
    
    // Habit 관련
    func fetchAllHabits() -> [Habit]
    func fetchFilteredHabits(showAll: Bool, hideCompleted: Bool) -> [Habit]
    func addHabit(_ habit: Habit)
    func updateHabit(_ habit: Habit, name: String, iter: [Int])
    func deleteHabit(_ habit: Habit)
    
    func countTodayHabit() -> Int
    func weeklySummary() -> [Int]
    func monthSummary() -> (Int, Int)
    func updateContinuity()
    func resetContinuity()
    
    // CompletedList 관련
    func toggleCompleted(id: String)
    func deleteCompletedList(for date: String)
    func countCompletedList(for date: String) -> Int
    func isDoneToday(id: String) -> Bool
    func countCompletedTodayHabit() -> Int
    func countCompletedYesterdayHabit() -> Int
    func getContinuity(status: CompleteStatus, isToday: Bool) -> Int
}
