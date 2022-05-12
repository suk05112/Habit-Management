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

//    @Published var items = RealmSwift.List<Year>()
    var selectedGroup: Statics? = nil

    var realm: Realm? = try? Realm()
    var Static: Results<Statics>?
    let calendar = Calendar(identifier: .gregorian)
    let dateFormatter = DateFormatter()

    private init() {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let realm = try? Realm()
        self.realm = realm
        
        if let group = realm?.objects(Statics.self) {
            self.Static = group
        }else {
            
            try? realm?.write({
                let group = Statics()
                realm?.add(group)
                
//                group.items.append(Year(dayArray: get7days(), weekArray: getWeeks(), monthArray: getMonth()))

            })
        }
        
//        add()
    }
    
    func addOrUpdate(){
        try? realm!.write{
            realm!.add(Statics(dayArray: get7days(), weekArray: getWeeks(), monthArray: getMonth(), total: getTotal()))
        }
    }
    
    func getData(selected: Int) -> [Int]{
        switch selected{
        case 1:
            return get7days()
        case 2:
            return getWeeks()
        case 3:
            return getMonth()
            
        default:
            return []
        }
    }
    
    func get7days() -> [Int]{
        let object = realm!.objects(CompletedList.self)

        var dayArray: [Int] = []
        let str_today = dateFormatter.string(from: Date())
        let date_today = dateFormatter.date(from: str_today)!

        var i = 7
        var dayOffset = DateComponents(day: -7)
        let weekAgo = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!
        
        for item in object.reversed(){
            var day = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!

            if weekAgo < item.date && i>1{
                while(item.date != day && i>1){
                    dayArray.append(0)
                    i -= 1
                    dayOffset = DateComponents(day: -i)
                    day = dateFormatter.string(for: calendar.date(byAdding: dayOffset, to: date_today))!

                    
                }
                dayArray.append(item.completed.count)
            }
            else{
                break
            }
        
        }
        
        print(dayArray.reversed())
        return dayArray.reversed()
        
    }
    
    func getWeeks()->[Int]{
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")
        
        let object = realm!.objects(CompletedList.self)

        var weekArray: [Int] = Array(repeating: 0, count: 52)
                
        for item in object{
            let date = dateFormatter.date(from: item.date)!
            let weekNO = Calendar.current.dateComponents([.weekOfYear], from: date).weekOfYear!
            
            weekArray[weekNO-1] += item.completed.count

        }
        
        var weekStr: [String] = []
        var weekno = getWeekOfNO(date: Date())

        var month = Calendar.current.dateComponents([.month], from: Date()).month!
        var day = Calendar.current.dateComponents([.day], from: Date()).day!
        
        for _ in 0..<5{
            weekStr.append("\(month)월 - \(weekno)주")
            weekno -= 1
            if weekno < 1{
                month -= 1
                let prevMonth = DateComponents(year: 2020, month: month-1, day: 18, hour: 21)
                weekno = getWeekOfNO(date: calendar.date(byAdding: .day, value: -day, to: Date())!)

            }

        }
        
        print(weekStr)
        
        let b = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
        let a = b-5

        
        return Array(weekArray[a..<b])
    }
    
    func getWeekOfNO(date: Date) -> Int{
        
        print("in getWeekOfNO date", date)
        
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)! //이번달 1일
        var weekNo = Calendar.current.dateComponents([.weekOfMonth], from: date).weekOfMonth! //오늘이 이번 달 몇주차인지
        
        if Calendar.current.dateComponents([.weekday], from: startOfMonth).weekday! > 4{
            weekNo -= 1
        }
        
        return weekNo
    }
    
    func getMonth() -> [Int]{

        let object = realm!.objects(CompletedList.self)

        var monthArray: [Int] = Array(repeating: 0, count: 12)
        
        //월 구하기
        let str = "0000-00-00"
        let start = str.index(str.startIndex, offsetBy: 5)
        let end = str.index(str.endIndex, offsetBy: -3)
        
        for item in object{
            var month1 = Int(item.date.substring(with:start..<end))!
            monthArray[month1-1] += 1

        }
        
        return monthArray
        
    }
    
    func getTotal() -> Int{
        return getMonth().count
    }
    

    
}
