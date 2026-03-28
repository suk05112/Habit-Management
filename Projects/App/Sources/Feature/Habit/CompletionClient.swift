//
//  CompletionClient.swift
//  Habit Management
//
//  Created by 남경민 on 5/25/25.
//

import Foundation
import RealmSwift
import ComposableArchitecture

struct CompletionClient {
    var toggle: @Sendable (String) async throws -> Void
    var deleteListForDate: @Sendable (String) async throws -> Void
    var countForDate: @Sendable (String) async throws -> Int
    var statistics: @Sendable (Total) async throws -> Int
    var isDoneToday: @Sendable (String) async throws -> Bool
    var todayHabitCompleteCount: @Sendable () async throws -> Int
    var yesterdayHabitCompleteCount: @Sendable () async throws -> Int
}

extension CompletionClient: DependencyKey {
    static let liveValue = CompletionClient(
        toggle: { id in
            let realm = try Realm()
            let todayKey = DateFormatters.standard.string(from: Date())
            let yesterdayKey = DateFormatters.standard.string(from: Date().adding(-1))

            // was: 첫 write(완료 목록 토글) 직전 — 지금 탭하기 전에 오늘 완료였는지
            // now: 그 write 이후 목록 기준 — 탭한 뒤 오늘 완료인지 (연속일·sortOrder 판단에 사용)
            // was && !now → 방금 "완료 취소"한 경우만 true (미완료 맨 아래 sortOrder)
            let wasCompletedToday =
                realm.object(ofType: CompletedList.self, forPrimaryKey: todayKey)?
                .completed.contains(id) == true

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

            // 토글한 습관만 연속 일수 갱신 (기존 HabitViewModel.setContiuity와 동일)
            // 이전 구현은 매 토글마다 '오늘 완료된 모든 습관'에 +1 해서 취소해도 숫자가 꼬였음.
            guard let habit = realm.objects(Habit.self).first(where: { $0.id == id }) else { return }

            let completedToday = realm.object(ofType: CompletedList.self, forPrimaryKey: todayKey)?.completed
                ?? List<String>()
            let doneYesterday = realm.object(ofType: CompletedList.self, forPrimaryKey: yesterdayKey)?
                .completed.contains(id) == true
            /// 토글 반영 후 오늘 완료 목록에 id가 있는지 (`wasCompletedToday`와 짝으로 취소 여부 구분)
            let nowCompletedToday = completedToday.contains(id)

            try realm.write {
                if !doneYesterday {
                    habit.continuity = 0
                }
                if completedToday.contains(id) {
                    habit.continuity += 1
                } else if habit.continuity > 0 {
                    habit.continuity -= 1
                }

                // 완료 취소 → 미완료 그룹 맨 아래: 자기 자신 제외한 '오늘 미완료' 습관 중 최대 sortOrder 다음
                if wasCompletedToday && !nowCompletedToday {
                    let doneSet = Set(completedToday.map { $0 })
                    let maxAmongOtherIncomplete = realm.objects(Habit.self)
                        .filter { $0.id != id && !doneSet.contains($0.id ?? "") }
                        .map(\.sortOrder)
                        .max() ?? -1
                    habit.sortOrder = maxAmongOtherIncomplete + 1
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
        
        statistics: { staticCase in
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
        
    )
}
