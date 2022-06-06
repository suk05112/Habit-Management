//
//  StaticVM.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/11.
//

import Foundation
import RealmSwift
import SwiftUI

class StaticVM: ObservableObject {
    
    static let shared = StaticVM()

    @Published var day:[Int] = []
    @Published var week:[Int] = []
    @Published var month:[Int] = []
    @Published var yearTotal:Int = 0
    @Published var total:Int = 0

    var selectedGroup: Statics? = nil

    var realm: Realm? = try? Realm()
    var Static: Results<Statics>?
    let calendar = Calendar(identifier: .gregorian)
    let dateFormatter = DateFormatter()
    
    let formatter_year = DateFormatter()
    let current_year: Int
    
    private init() {
        
        print("Static init")

        dateFormatter.dateFormat = "yyyy-MM-dd"
        formatter_year.dateFormat = "yyyy"
        current_year = Int(formatter_year.string(from: Date()))!
        
        day = NSArray(array: Array(get7days().0)) as! [Int]
        week = NSArray(array: Array(getWeeks().0)) as! [Int]
        month = NSArray(array: Array(getMonth().0)) as! [Int]
        yearTotal = getYearTotal()
        
        let realm = try? Realm()
        self.realm = realm
        
        if let group = realm?.objects(Statics.self) {
            self.Static = group
        }else {
            
            try? realm?.write({
                let group = Statics(year: current_year, dayArray: day, weekArray: week, monthArray: month, total: yearTotal)
                realm?.add(group)

            })
        }
        total = getTotal()
        
    }
    
    func addOrUpdate(){

        day = NSArray(array: Array(get7days().0)) as! [Int]
        week = NSArray(array: Array(getWeeks().0)) as! [Int]
        month = NSArray(array: Array(getMonth().0)) as! [Int]
        yearTotal = getYearTotal()

        try? realm!.write{
//            realm!.add(Statics(year: current_year ,dayArray: get7days().0, weekArray: getWeeks().0, monthArray: getMonth().0, total: getYearTotal()))
            realm!.add(Statics(year: current_year ,dayArray:day, weekArray: week, monthArray: month, total: yearTotal), update: .modified)
        }
        total = getTotal()

    }
    
    func get7days() -> ([Int],[String]){ //최근 7일
        var object = Array(realm!.objects(CompletedList.self))

        if object.count<7{
            for _ in 0..<(7-object.count){
                object.append(CompletedList())
            }
                    
        }
        var dayStr: [String] = []
        var dayArray: [Int] = Array(repeating: 0, count: 7)
        let str_today = dateFormatter.string(from: Date())
        let date_today = dateFormatter.date(from: str_today)!

        let dayOffset = DateComponents(day: -7)
        let weekAgo = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!
        print("week ago =" , weekAgo)

        for i in 0..<7{
            let myday = dateFormatter.string(for: calendar.date(byAdding: DateComponents(day: -i), to: date_today))!
            dayStr.append(myday)
            
        }
        for item in object.reversed()[0..<7]{
            for i in 0..<dayStr.count{
                if dayStr[i] == item.date{
                    dayArray[i] = item.completed.count
                    break
                }
            }
        }
    
        dayStr.forEach{ str in
            if let index = dayStr.firstIndex(where: { $0 ==  str }) {
                dayStr[index] = str.convert()
            }
        }
//        print(dayArray.reversed())
//        print(dayStr.reversed())
        return (dayArray.reversed(), dayStr.reversed())
        
    }
    
    func getWeeks()->([Int], [String]){ //52주에 대한 데이터
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")
        
        
        let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
        
        var weekArray: [Int]
        
        if let week = realm?.objects(Statics.self).filter(NSPredicate(format: "year == \(2022)")).first?.week{
            weekArray = Array(week)
        }
        else{
            weekArray = Array(repeating: 0, count: 52)
        }
        


        print("in getweeks")
 
        if let completed = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", dateFormatter.string(from: Date()))).first?.completed {
            print(completed)
            weekArray[weekNO-1] = completed.count
        }
        
        
        /*
        let object = realm?.objects(CompletedList.self)
        if object?.first?.date != "" {
                    
            for item in object!{
                let date = dateFormatter.date(from: item.date)!
                let weekNO = Calendar.current.dateComponents([.weekOfYear], from: date).weekOfYear!
                
                weekArray[weekNO-1] = item.completed.count

            }
        }
        */
        
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
        
//        print(weekStr)
        


        return (Array(weekArray), weekStr.reversed())
    }
    
    func getWeekOfNO(date: Date) -> Int{
        
//        print("in getWeekOfNO date", date)
        
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)! //이번달 1일
        var weekNo = Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth! //오늘이 이번 달 몇주차인지
        
        if Calendar.current.dateComponents([.weekday], from: startOfMonth).weekday! > 4{
            weekNo -= 1
        }
        
        return weekNo
    }
    
    func getMonth() -> ([Int], [String]){

        let object = realm?.objects(CompletedList.self)

        var monthArray: [Int] = Array(repeating: 0, count: 12)
        var monthStr: [String] = []
        
        for i in 1...12{
            monthStr.append(Month(rawValue: i)!.description)
        }
        //월 구하기
        let str = "0000-00-00"
        let start = str.index(str.startIndex, offsetBy: 5)
        let end = str.index(str.endIndex, offsetBy: -3)
        
        if object?.first?.date != "" {

            for item in object!{
                let month1 = Int(item.date.substring(with:start..<end))!
                monthArray[month1-1] += item.completed.count
            }
        }
        
        return (monthArray, monthStr)
        
    }
    
    func getYearTotal() -> Int{
        return getMonth().0.reduce(0, +)
    }
    
    func getTotal() -> Int{
        let object = realm!.objects(Statics.self)
        return Array(object).reduce(0){ $0 + $1.total}
    }
    
    func getData(selected: Int)-> [Int]{
        switch selected{
        case 1:
            return day
        case 2:
            let b = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
            let a = b-5
            return Array(week[a..<b])
        case 3:
            return month
        default:
            return []
        }
    }
    
    func getStr(selected: Int)-> [String]{
        
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
    }
    
}

extension String {
    func toDate() -> Date? {//"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월\ndd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self.toDate()!)
    }
    
    func convert() -> String{
        let monthFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.locale = Locale(identifier: "ko_KR")

        monthFormatter.timeZone = TimeZone(abbreviation: "KST")
        dayFormatter.timeZone = TimeZone(abbreviation: "KST")

        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        
        let month = Int(monthFormatter.string(from: self.toDate()!))!
        let day = dayFormatter.string(from: self.toDate()!)

//        return "\(Month(rawValue: month)!.description)\n\(day)"
        return "\(day)일"

    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월\ndd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
}

