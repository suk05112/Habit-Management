//
//  StaticsClient.swift
//  Habit Management
//
//  Created by 한수진 on 5/28/25.
//

import RealmSwift
import ComposableArchitecture
import Foundation

struct StatisticsClient {
    var getInitialStatisticsData: () async -> StatisticsData
    var addOrUpdate: () async -> StatisticsData
    var getStr: (_ selected: Int) -> [String]
    var updateTodoPerDay: () -> Void
    var updateTodoPerWeek: (_ add: Bool, _ numberOfIter: Int) -> Void
    var updateTodoPerMonth: (_ add: Bool, _ numberOfIter: Int) -> Void
    var getTodoStatistics: () async -> Statistics

    static func getWeekOfNO(date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)

        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)! //이번달 1일
        var weekNo = Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth! //오늘이 이번 달 몇주차인지

        if Calendar.current.dateComponents([.weekday], from: startOfMonth).weekday! > 4{
            weekNo -= 1
        }

        return weekNo
    }

    static func get7days() -> ([Int],[String]) { // 최근 7일
        let realm: Realm? = try? Realm()
        var object = Array(realm!.objects(CompletedList.self))

        let dateFormatter = DateFormatter()
        let formatterYear = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        formatterYear.dateFormat = "yyyy"

        if object.count<7{
            for _ in 0..<(7-object.count){
                object.append(CompletedList())
            }
        }

        var dayStr: [String] = []
        var dayArray: [Int] = Array(repeating: 0, count: 7)
        let stringToday = dateFormatter.string(from: Date())
        let dateToday = dateFormatter.date(from: stringToday)!

        let dayOffset = DateComponents(day: -7)
        let weekAgo = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: dateToday))!

        print("week ago =" , weekAgo)

        for dayOffsetIndex in 0..<7 {
            let myDay = dateFormatter.string(
                for: calendar.date(byAdding: DateComponents(day: -dayOffsetIndex), to: dateToday)
            )!
            dayStr.append(myDay)
        }

        for item in object.reversed()[0..<7] {
            for dayStrIndex in 0..<dayStr.count {
                if dayStr[dayStrIndex] == item.date {
                    dayArray[dayStrIndex] = item.completed.count
                    break
                }
            }
        }

        dayStr.forEach{ str in
            if let index = dayStr.firstIndex(where: { $0 ==  str }) {
                dayStr[index] = str.convert()
            }
        }
        return (dayArray.reversed(), dayStr.reversed())

    }

    static func getWeeks()->([Int], [String]) { //52주에 대한 데이터
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

        if object!.count>1 {
            for item in object!.reversed()[0..<object!.endIndex-1]{
                if weekNO != Calendar.current.dateComponents([.weekOfYear], from: dateFormatter.date(from: item.date)!).weekOfYear!{
                    break
                }
                weekArray[weekNO-1] += item.completed.count

            }
        }

        var weekStr: [String] = []
        var weekno = getWeekOfNO(date: Date())

        var month = Calendar.current.dateComponents([.month], from: Date()).month!
        let day = Calendar.current.dateComponents([.day], from: Date()).day!

        for _ in 0..<5{
            weekStr.append("\(month)월\n\(weekno)주")
            weekno -= 1
            if weekno < 1{
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

        for monthNumber in 1...12 {
            monthStr.append(Month(rawValue: monthNumber)!.description)
        }
        //월 구하기
        let str = "0000-00-00"
        let start = str.index(str.startIndex, offsetBy: 5)
        let end = str.index(str.endIndex, offsetBy: -3)

        if let object = realm?.objects(CompletedList.self){
            for item in object{
                if item.date != "" {
                    let month1 = Int(item.date.substring(with:start..<end))!
                    monthArray[month1-1] += item.completed.count
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
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(todayWeek-1)))

        //일-1, 토-7
        for _ in stride(from: 0, to: todayWeek, by: 1){
            let date = dateFormatter.string(from: startDate)
            temp.append(date)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

        }

        for _ in 0..<(7-todayWeek){
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
        return Array(object).reduce(0){ $0 + $1.total}
    }
}

extension StatisticsClient : DependencyKey {
    static let liveValue = StatisticsClient(
        getInitialStatisticsData : {
            print("Static init")
            let dateFormatter = DateFormatter()
            let formatterYear = DateFormatter()
            let calendar = Calendar(identifier: .gregorian)

            dateFormatter.dateFormat = "yyyy-MM-dd"
            formatterYear.dateFormat = "yyyy"
            let currentYear = Int(formatterYear.string(from: Date()))!

            var realm: Realm? = try? Realm()
            var statisticsResults: Results<Statistics>?
            let day = NSArray(array: Array(get7days().0)) as? [Int] ?? []
            let week = NSArray(array: Array(getWeeks().0)) as? [Int] ?? []
            let month = NSArray(array: Array(getMonth().0)) as? [Int] ?? []
            let yearTotal = getYearTotal()
            let thisWeek = getThisWeekDayArray()
    //        let myFilter = NSPredicate(format: "year == %@", currentYear)

    //        if let group = realm?.objects(Statics.self) {
            if realm!.objects(Statistics.self).where({($0.classification == "Todo")}).first != nil{
                statisticsResults = realm?.objects(Statistics.self)
            }
            else{
                try? realm?.write({
                    realm?.add(Statistics(classification: "Done", year: currentYear, dayArray: day, weekArray: week, monthArray: month, total: yearTotal))
                    realm?.add(Statistics(classification: "Todo", year: currentYear, dayArray: day, weekArray: week, monthArray: month, total: yearTotal))
                })
            }

            let total = getTotal()

            return StatisticsData(day: day, week: week, month: month, yearTotal: yearTotal, total: total, thisWeek: thisWeek)
        },

        addOrUpdate: {
            let calendar = Calendar(identifier: .gregorian)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let realm = try? Realm() else {
                return StatisticsData()
            }

            let day = NSArray(array: Array(get7days().0)) as? [Int] ?? []
            let week = NSArray(array: Array(getWeeks().0)) as? [Int] ?? []
            let month = NSArray(array: Array(getMonth().0)) as? [Int] ?? []
            let yearTotal = getYearTotal()

            let object = realm.objects(Statistics.self).where{$0.classification == "Done"}.first!

            try? realm.write {
                object.dayArray = day
                object.weekArray = week
                object.monthArray = month
                object.total = yearTotal
            }

            let total = getTotal()
            let thisWeek = getThisWeekDayArray()

            return StatisticsData(day: day, week: week, month: month, yearTotal: yearTotal, total: total, thisWeek: thisWeek)
        },

        getStr: {selected in
            switch selected{
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

        updateTodoPerDay: {
            var realm: Realm? = try? Realm()
            let object = Array(realm!.objects(Habit.self))
            var dayArray = Array(repeating: 0, count: 7)

            for item in object{
                item.weekIter.forEach{
                    dayArray[$0-1] += 1
                }
            }

            try? realm!.write{
                realm!.objects(Statistics.self).where{($0.classification == "Todo")}.first!.dayArray = dayArray
            }
        },
        updateTodoPerWeek: { add, numberOfIter in
            var realm: Realm? = try? Realm()
            var weekArray = Array(realm!.objects(Statistics.self).where{($0.classification == "Todo")}.first!.weekArray)
            let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!

            if weekArray[weekNO-1] == 0{
                weekArray[weekNO-1] = weekArray[weekNO-2]
            }

            if add {
                weekArray[weekNO-1] += numberOfIter
            } else {
                weekArray[weekNO-1] -= numberOfIter
            }

            try? realm!.write{
                realm!.objects(Statistics.self).where{($0.classification == "Todo")}.first!.weekArray = weekArray
            }
        },
        updateTodoPerMonth: { add, numberOfIter in
            var realm: Realm? = try? Realm()

            var monthArray = Array(realm!.objects(Statistics.self).where { ($0.classification == "Todo") }.first!.monthArray)
            let todayMonth = Calendar.current.dateComponents([.month], from: Date()).month!

            if monthArray[todayMonth-1] == 0 {
                monthArray[todayMonth-1] = monthArray[todayMonth-2]
            }

            if add {
                monthArray[todayMonth-1] += numberOfIter
            } else {
                monthArray[todayMonth-1] -= numberOfIter
            }

            try? realm!.write{
                realm!.objects(Statistics.self).where{($0.classification == "Todo")}.first!.monthArray = monthArray
            }
        },
        getTodoStatistics: {
            var realm: Realm! = try? Realm()

           guard let statistics = realm.objects(Statistics.self).where({ $0.classification == "Todo" }).first else {
                    return Statistics() // 또는 예외 처리
                }
            return Statistics(
                classification: statistics.classification,
                year: statistics.year,
                dayArray: Array(statistics.dayArray),
                weekArray: Array(statistics.weekArray),
                monthArray: Array(statistics.monthArray),
                total: statistics.total
            )
        }
    )
}

struct StatisticsData: Equatable {
    var day: [Int] = [] // 최근 7일에 대한 데이터
    var week: [Int] = [] // 52주에 대한 데이터
    var month: [Int] = [] // 달에 완료한 습관에 대한 데이터
    var yearTotal: Int = 0 // 1년동안 완료한 습관의 갯수
    var total: Int = 0 // 완료한 모든 습관
    var thisWeek: [String] = [] // 이번주에 대한 데이터
}

extension DependencyValues {
    var statisticsDataClient: StatisticsClient {
        get { self[StatisticsClient.self] }
        set { self[StatisticsClient.self] = newValue }
    }
}
