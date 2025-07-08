//
//  StaticsClient.swift
//  Habit Management
//
//  Created by 한수진 on 5/28/25.
//

import ComposableArchitecture
import Foundation
import RealmSwift

struct StatisticsClient {
    var getInitialStatisticsData: () async -> StatisticsData
    var addOrUpdate: () async -> StatisticsData
    var getStr: (_ selected: Int) -> [String]
    var setnumOfToDoPerDay: () -> Void
    var setnumOfToDoPerWeek: (_ add: Bool, _ numOfIter: Int) -> Void
    var setnumOfToDoPerMonth: (_ add: Bool, _ numOfIter: Int) -> Void
    var getnumOfToDo: () async -> Statistics

    static func getWeekOfNO(date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)

        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!  //이번달 1일
        var weekNo = Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth!  //오늘이 이번 달 몇주차인지

        if Calendar.current.dateComponents([.weekday], from: startOfMonth).weekday! > 4 {
            weekNo -= 1
        }

        return weekNo
    }

    static func get7days() -> ([Int], [String]) {  // 최근 7일
        let realm: Realm? = try? Realm()
        var object = Array(realm!.objects(CompletedList.self))

        let dateFormatter = DateFormatter()
        let formatter_year = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        formatter_year.dateFormat = "yyyy"

        if object.count < 7 {
            for _ in 0..<(7 - object.count) {
                object.append(CompletedList())
            }
        }

        var dayStr: [String] = []
        var dayArray: [Int] = Array(repeating: 0, count: 7)
        let str_today = dateFormatter.string(from: Date())
        let date_today = dateFormatter.date(from: str_today)!

        let dayOffset = DateComponents(day: -7)
        let weekAgo = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!

        print("week ago =", weekAgo)

        for i in 0..<7 {
            let myday = dateFormatter.string(
                for: calendar.date(byAdding: DateComponents(day: -i), to: date_today))!
            dayStr.append(myday)

        }

        for item in object.reversed()[0..<7] {
            for i in 0..<dayStr.count {
                if dayStr[i] == item.date {
                    dayArray[i] = item.completed.count
                    break
                }
            }
        }

        dayStr.forEach { str in
            if let index = dayStr.firstIndex(where: { $0 == str }) {
                dayStr[index] = str.convert()
            }
        }
        return (dayArray.reversed(), dayStr.reversed())

    }

    static func getWeeks() -> ([Int], [String]) {  //52주에 대한 데이터
        let realm: Realm? = try? Realm()

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")

        var weekArray: [Int] = Array(repeating: 0, count: 52)

        /*
        if let week = realm?.objects(Statics.self).filter(NSPredicate(format: "year == \(2022)")).first?.week{
            weekArray = Array(week)
        }
        else{
            weekArray = Array(repeating: 0, count: 52)
        }
        */

        //print("in getweeks")

        let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!

        /*
        var total = 0
        
        for item in object.reversed()[0..<7]{
            let itemWeekNo = Calendar.current.dateComponents([.weekOfYear], from: dateFormatter.date(from: item.date)!).weekOfYear!
            if itemWeekNo == weekNO{
                total += item.completed.count
            }
            else{
                break
            }
        
        }
        weekArray[weekNO-1] = total
        
        */

        let object = realm?.objects(CompletedList.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if object!.count > 1 {
            for item in object!.reversed()[0..<object!.endIndex - 1] {
                if weekNO != Calendar.current.dateComponents(
                    [.weekOfYear], from: dateFormatter.date(from: item.date)!
                ).weekOfYear! {
                    break
                }
                weekArray[weekNO - 1] += item.completed.count

            }
        }

        var weekStr: [String] = []
        var weekno = getWeekOfNO(date: Date())

        var month = Calendar.current.dateComponents([.month], from: Date()).month!
        let day = Calendar.current.dateComponents([.day], from: Date()).day!

        for _ in 0..<5 {
            weekStr.append("\(month)월\n\(weekno)주")
            weekno -= 1
            if weekno < 1 {
                month -= 1

                weekno = getWeekOfNO(date: calendar.date(byAdding: .day, value: -day, to: Date())!)
            }
        }

        return (Array(weekArray), weekStr.reversed())
    }

    static func getMonth() -> ([Int], [String]) {
        let realm: Realm? = try? Realm()
        _ = realm?.objects(CompletedList.self)

        var monthArray: [Int] = Array(repeating: 0, count: 12)
        var monthStr: [String] = []

        for i in 1...12 {
            monthStr.append(Month(rawValue: i)!.description)
        }
        //월 구하기
        let str = "0000-00-00"
        let start = str.index(str.startIndex, offsetBy: 5)
        let end = str.index(str.endIndex, offsetBy: -3)

        if let object = realm?.objects(CompletedList.self) {
            for item in object {
                if item.date != "" {
                    let month1 = Int(item.date.substring(with: start..<end))!
                    monthArray[month1 - 1] += item.completed.count
                }
            }
        }

        return (monthArray, monthStr)
    }

    static func getThisWeekDayArray() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar(identifier: .gregorian)

        var temp: [String] = []
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600 * 24 * (todayWeek - 1)))

        //일-1, 토-7
        for _ in stride(from: 0, to: todayWeek, by: 1) {
            let date = dateFormatter.string(from: startDate)
            temp.append(date)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

        }

        for _ in 0..<(7 - todayWeek) {
            temp.append("")
        }
        //        thisWeek = temp
        //        print(thisWeek)
        return temp
    }

    static func getYearTotal() -> Int {
        return getMonth().0.reduce(0, +)
    }

    static func getTotal() -> Int {
        let realm: Realm? = try? Realm()
        let object = realm!.objects(Statistics.self)
        return Array(object).reduce(0) { $0 + $1.total }
    }
}

extension StatisticsClient: DependencyKey {
    static let liveValue: StatisticsClient = {
        let statisticsManager = RealmManager<Statistics>(configuration: nil, fileUrl: nil)
        let completionManager = RealmManager<CompletedList>(configuration: nil, fileUrl: nil)
        let habitManager = RealmManager<Habit>(configuration: nil, fileUrl: nil)

        let statisticsRepository = RealmStatisticsRepository(realmManager: statisticsManager)
        let completionRepository = RealmCompletionRepository(realmManager: completionManager)
        let habitRepository = RealmHabitRepository(realmManager: habitManager)

        return StatisticsClient(
            getInitialStatisticsData: {
                print("Static init")
                let current_year = Calendar.current.component(.year, from: Date())

                let day = Array(get7days().0)
                let week = Array(getWeeks().0)
                let month = Array(getMonth().0)
                let yearTotal = getYearTotal()
                let thisWeek = getThisWeekDayArray()

                // Repository를 통해 통계 데이터 확인 및 생성
                let existingTodoStats = try await statisticsRepository.read(
                    classification: "Todo", year: current_year)

                if existingTodoStats == nil {
                    let doneStats = StatisticsModel(
                        year: current_year,
                        days: day,
                        week: week,
                        month: month,
                        total: yearTotal,
                        classification: "Done"
                    )
                    let todoStats = StatisticsModel(
                        year: current_year,
                        days: day,
                        week: week,
                        month: month,
                        total: yearTotal,
                        classification: "Todo"
                    )

                    try await statisticsRepository.create(doneStats)
                    try await statisticsRepository.create(todoStats)
                }

                let total = getTotal()

                return StatisticsData(
                    day: day, week: week, month: month, yearTotal: yearTotal, total: total,
                    thisWeek: thisWeek)
            },

            addOrUpdate: {
                let day = Array(get7days().0)
                let week = Array(getWeeks().0)
                let month = Array(getMonth().0)
                let yearTotal = getYearTotal()
                let current_year = Calendar.current.component(.year, from: Date())

                if let existingStats = try await statisticsRepository.read(
                    classification: "Done", year: current_year)
                {
                    let updatedStats = StatisticsModel(
                        year: current_year,
                        days: day,
                        week: week,
                        month: month,
                        total: yearTotal,
                        classification: "Done"
                    )
                    try await statisticsRepository.update(updatedStats)
                }

                let total = getTotal()
                let thisWeek = getThisWeekDayArray()

                return StatisticsData(
                    day: day, week: week, month: month, yearTotal: yearTotal, total: total,
                    thisWeek: thisWeek)
            },

            getStr: { selected in
                switch selected {
                case 1:
                    return get7days().1
                case 2:
                    return getWeeks().1
                case 3:
                    return getMonth().1
                default:
                    return []
                }
            },

            setnumOfToDoPerDay: {
                let habits = try await habitRepository.findAll()
                var dayArray = Array(repeating: 0, count: 7)

                for habit in habits {
                    habit.weekIter.forEach {
                        dayArray[$0 - 1] += 1
                    }
                }

                let current_year = Calendar.current.component(.year, from: Date())
                if let existingStats = try await statisticsRepository.read(
                    classification: "Todo", year: current_year)
                {
                    let updatedStats = StatisticsModel(
                        year: current_year,
                        days: dayArray,
                        week: existingStats.week,
                        month: existingStats.month,
                        total: existingStats.total,
                        classification: "Todo"
                    )
                    try await statisticsRepository.update(updatedStats)
                }
            },

            setnumOfToDoPerWeek: { add, numOfIter in
                let current_year = Calendar.current.component(.year, from: Date())
                if let existingStats = try await statisticsRepository.read(
                    classification: "Todo", year: current_year)
                {
                    var weekArray = existingStats.week
                    let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date())
                        .weekOfYear!

                    if weekArray[weekNO - 1] == 0 && weekNO > 1 {
                        weekArray[weekNO - 1] = weekArray[weekNO - 2]
                    }

                    if add {
                        weekArray[weekNO - 1] += numOfIter
                    } else {
                        weekArray[weekNO - 1] -= numOfIter
                    }

                    let updatedStats = StatisticsModel(
                        year: current_year,
                        days: existingStats.days,
                        week: weekArray,
                        month: existingStats.month,
                        total: existingStats.total,
                        classification: "Todo"
                    )
                    try await statisticsRepository.update(updatedStats)
                }
            },

            setnumOfToDoPerMonth: { add, numOfIter in
                let current_year = Calendar.current.component(.year, from: Date())
                if let existingStats = try await statisticsRepository.read(
                    classification: "Todo", year: current_year)
                {
                    var monthArray = existingStats.month
                    let todayMonth = Calendar.current.dateComponents([.month], from: Date()).month!

                    if monthArray[todayMonth - 1] == 0 && todayMonth > 1 {
                        monthArray[todayMonth - 1] = monthArray[todayMonth - 2]
                    }

                    if add {
                        monthArray[todayMonth - 1] += numOfIter
                    } else {
                        monthArray[todayMonth - 1] -= numOfIter
                    }

                    let updatedStats = StatisticsModel(
                        year: current_year,
                        days: existingStats.days,
                        week: existingStats.week,
                        month: monthArray,
                        total: existingStats.total,
                        classification: "Todo"
                    )
                    try await statisticsRepository.update(updatedStats)
                }
            },

            getnumOfToDo: {
                let current_year = Calendar.current.component(.year, from: Date())
                if let statistics = try await statisticsRepository.read(
                    classification: "Todo", year: current_year)
                {
                    // StatisticsModel을 Statistics (Realm Object)로 변환
                    return statistics.toRealmEntity()
                }
                return Statistics()
            }
        )
    }()
}

struct StatisticsData: Equatable {
    var day: [Int] = []  // 최근 7일에 대한 데이터
    var week: [Int] = []  // 52주에 대한 데이터
    var month: [Int] = []  // 달에 완료한 습관에 대한 데이터
    var yearTotal: Int = 0  // 1년동안 완료한 습관의 갯수
    var total: Int = 0  // 완료한 모든 습관
    var thisWeek: [String] = []  // 이번주에 대한 데이터
}

extension DependencyValues {
    var statisticsDataClient: StatisticsClient {
        get { self[StatisticsClient.self] }
        set { self[StatisticsClient.self] = newValue }
    }
}
