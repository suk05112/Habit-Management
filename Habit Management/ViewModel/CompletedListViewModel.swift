//
//  CompletedListViewModel.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import RealmSwift
import SwiftUI

class CompletedListViewModel: ObservableObject {

    static let shared = CompletedListViewModel()
    let dateFormatter = DateFormatter()

    var realm: Realm?
    var list: CompletedList?
    @Published var todayDoneList: CompletedList
    var todayAllDone = false
    var isTodayHabit = false

    private init() {

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        let today = dateFormatter.string(from: Date())

        let realm = try? Realm()
        self.realm = realm

        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "2022-06-14"))

        if let group = realm?.objects(CompletedList.self).first {
            self.list = group
        } else {

            try? realm?.write({
                let group = CompletedList()
                realm?.add(group)

            })
        }

        if let todaydone = realm?.object(ofType: CompletedList.self, forPrimaryKey: today) {
            todayDoneList = todaydone
        } else {
            todayDoneList = CompletedList()
        }

        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        if isTodayHabitComplete() == Week(rawValue: todayWeek)!.total {
            todayAllDone = true
        }
    }

    func delete() {
        print("Delete")
        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "2022-04-30")).first
        try! realm?.write {
            realm?.delete(item!)
        }
    }

    func complete(id: String) {
        let today = dateFormatter.string(from: Date())
        let object2 = realm?.object(ofType: CompletedList.self, forPrimaryKey: today)

        if let object = object2 {
            if object2?.completed.contains(id) == false {
                try? realm?.write {
                    object.completed.append(id)
                }
                CompletedListViewModel.shared.setAllDoneContinuityUntilToday(status: .complete, isToday: isTodayHabit)
            } else {
                try? realm?.write {
                    if let index = object.completed.firstIndex(of: id) {
                        object.completed.remove(at: index)
                    }
                }

                CompletedListViewModel.shared.setAllDoneContinuityUntilToday(status: .cancel, isToday: isTodayHabit)
            }
        } else {
            try? realm?.write {
                realm?.add(CompletedList(today: today, iter: [id]))
            }
            CompletedListViewModel.shared.setAllDoneContinuityUntilToday(status: .complete, isToday: isTodayHabit)
        }

        if let todaydone = realm?.object(ofType: CompletedList.self, forPrimaryKey: today) {
            todayDoneList = todaydone
        }
    }

    func setAllDoneContinuityUntilYesterday() {

        let yesterDayDate = Date(timeInterval: -60*60*24, since: Date())
        let yesterDay = dateFormatter.string(from: yesterDayDate)
        let yerterDayComplete = realm?.object(ofType: CompletedList.self, forPrimaryKey: yesterDay)

        let todoCount = StatisticsViewModel.shared.getNumberOfTodoPerDay()
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!

        let yesterdayTodo = todoCount[(todayWeek-2+7)%7]

        if UserDefaults.standard.object(forKey: "allDoneContinuity") == nil ||
            yerterDayComplete == nil || yesterdayTodo != isYesterdayHabitComplete() {
            UserDefaults.standard.set(0, forKey: "allDoneContinuity")
        }
    }

    func setAllDoneContinuityUntilToday(status: CompleteStatus, isToday: Bool) {
        if isToday {
            setAllDoneContinuityUntilYesterday()

            let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
            let allDoneContinuity = UserDefaults.standard.integer(forKey: "allDoneContinuity")

            var today: Int = 0
            if !todayAllDone {
                if isTodayHabitComplete() == Week(rawValue: todayWeek)!.total {
                    todayAllDone = true
                    today = 1
                }
            } else if todayAllDone {
                if status == .cancel || status == .add {
                    todayAllDone = false
                    if allDoneContinuity > 0 {
                        today = -1
                    }
                }
            }

            UserDefaults.standard.set(allDoneContinuity + today, forKey: "allDoneContinuity")
        }

        print("alldone Continue", UserDefaults.standard.integer(forKey: "allDoneContinuity"))
    }

    /// 날짜(yyyy-MM-dd)별 완료 개수. `refresh()`·전체 스캔 없이 primary key만 조회 (달력 등 고빈도 호출 대비).
    func getCount(date: String) -> Int {
        guard let realm else { return 0 }
        return realm.object(ofType: CompletedList.self, forPrimaryKey: date)?.completed.count ?? 0
    }

    func getStatistics(staticCase: Total) -> Int {

        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let str_today = dateFormatter.string(from: Date())
        let date_today = dateFormatter.date(from: str_today)!

        var ans = 0
        let object = realm!.objects(CompletedList.self)
        let todayComps = Calendar.current.dateComponents([.year, .month, .weekday, .weekOfMonth], from: date_today)

        let year = todayComps.year!
        let month = todayComps.month!
        let weekDay = todayComps.weekday!

        let dayOffset = DateComponents(day: -weekDay)
        let weekAgo = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!

        switch staticCase {
        case .week:
            for item in object.reversed() {
                if item.date > weekAgo {
                    ans += item.completed.count
                } else {
                    break
                }
            }

        case .month:
            let str = "0000-00-00"
            let start = str.index(str.startIndex, offsetBy: 5)
            let end = str.index(str.endIndex, offsetBy: -3)
            for item in object {
                if Int(item.date.substring(with: start..<end)) == month {
                    ans += item.completed.count
                }
            }
        case .year:
            for item in object {
                if Int(item.date.prefix(4)) == year {
                    ans += item.completed.count
                }
            }

        case .all:
            for item in object {
                ans += item.completed.count
            }
        }

        return ans
    }

    func isDoneToday(id: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str_today = dateFormatter.string(from: Date())

        if let completed = realm?.object(ofType: CompletedList.self, forPrimaryKey: str_today) {
            if completed.completed.contains(id) {
                return true
            }
        }
        return false
    }

    func isTodayHabitComplete() -> Int {
        var count = 0
        for item in HabitViewModel.shared.getTodayHabits() {
            if !isDoneToday(id: item.id!) {
                return -1
            }
            count += 1
        }
        return count
    }

    func isYesterdayHabitComplete() -> Int {
        var count = 0

        for item in HabitViewModel.shared.getYesterdayHabits() {
            if !HabitViewModel.shared.isDoneYesterday(id: item.id!) {
                return -1
            }
            count += 1
        }
        return count
    }

    func setIsToday(isToday: Bool) {
        isTodayHabit = isToday
    }

    func settodayAllDone(isToday: Bool) {
        self.todayAllDone = false
    }
}

enum CompleteStatus {
    case complete
    case add
    case delete
    case cancel
}
