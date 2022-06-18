//
//  compltedLIstVM.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import RealmSwift
import SwiftUI

class compltedLIstVM: ObservableObject {
    
    static let shared = compltedLIstVM()
    let dateFormatter = DateFormatter()

    var realm: Realm?
    var list: CompletedList?
    @Published var todayDoneList: CompletedList
    var todayAllDone = false
    var isTodayHabit = false
    
    private init(){

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        let today = dateFormatter.string(from: Date())
        
        let realm = try? Realm()
        self.realm = realm
        
        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "2022-06-14"))
//        try! realm?.write {
//            realm?.delete(item!)
//        }

        if let group = realm?.objects(CompletedList.self).first {
            self.list = group
        }else {
            
            try? realm?.write({
                let group = CompletedList()
                realm?.add(group)

            })
        }
        
        if let todaydone = realm?.object(ofType: CompletedList.self, forPrimaryKey: today){
            todayDoneList = todaydone
        }
        else{
            todayDoneList = CompletedList()
        }
        
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        if isTodayHabitComplete() == Week(rawValue: todayWeek)!.total{
            todayAllDone = true
        }
        //print("today done list", todayDoneList)
//        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "")).first

        
//        try? realm?.write {
//            realm?.add(CompletedList(today: "2022-04-29", iter: ["2022-04-30 06:25:51", "2022-04-30 07:04:02"]), update: .modified)
//        }
    }
    
    func delete(){
        print("Delete")
        //print(realm?.objects(CompletedList.self))
        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "2022-04-30")).first
        try! realm?.write {
            realm?.delete(item!)
        }
    }
    
    func complete(id: String){
        let today = dateFormatter.string(from: Date())
        let object2 = realm?.object(ofType: CompletedList.self, forPrimaryKey: today)
        
        if let object = object2{
            if object2?.completed.contains(id) == false{
                try? realm?.write {
                    object.completed.append(id)
                }
                compltedLIstVM.shared.setAllDoneContinuityUntilToday(status: .complete, isToday: isTodayHabit)
            }
            else{
                try? realm?.write {
                    if let index = object.completed.firstIndex(of: id) {
                        object.completed.remove(at: index)
                    }
                }

                compltedLIstVM.shared.setAllDoneContinuityUntilToday(status: .cancel, isToday: isTodayHabit)
            }
        }
        else{
            try? realm?.write {
                realm?.add(CompletedList(today: today, iter: [id]))
            }
            compltedLIstVM.shared.setAllDoneContinuityUntilToday(status: .complete, isToday: isTodayHabit)
        }
        
        
        if let todaydone = realm?.object(ofType: CompletedList.self, forPrimaryKey: today){
            todayDoneList = todaydone
        }


    }
    
    func setAllDoneContinuityUntilYesterDay(){

        let yesterDayDate = Date(timeInterval: -60*60*24, since: Date())
        let yesterDay = dateFormatter.string(from: yesterDayDate)
        let yerterDayComplete = realm?.object(ofType: CompletedList.self, forPrimaryKey: yesterDay)
        
        let todoCount = StaticVM.shared.getnumOfToDoPerDay()
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!

        let yesterdayTodo = todoCount[(todayWeek-2+7)%7]

        if UserDefaults.standard.object(forKey: "allDoneContinuity") == nil ||
            yerterDayComplete == nil ||  yesterdayTodo != isYesterdayHabitComplete(){
                UserDefaults.standard.set(0, forKey: "allDoneContinuity")
        }

    }
    
    func setAllDoneContinuityUntilToday(status: CompleteStatus, isToday: Bool){
        if isToday{
            setAllDoneContinuityUntilYesterDay()

            let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
            let allDoneContinuity = UserDefaults.standard.integer(forKey: "allDoneContinuity")

            var today: Int = 0
            if !todayAllDone{ //오늘 모든 습관을 완료 못했을 때
                if isTodayHabitComplete() == Week(rawValue: todayWeek)!.total{
                    todayAllDone = true
                    today = 1
                }

            }
            else if todayAllDone{ //오늘 모든 습관을 완료 했을 때
                if status == .cancel || status == .add {// 취소 또는 습관추가
                    todayAllDone = false
                    if allDoneContinuity > 0{
                        today = -1
                    }
                }
                    
            }
            
            UserDefaults.standard.set(allDoneContinuity + today, forKey: "allDoneContinuity")
        }


        print("alldone Continue", UserDefaults.standard.integer(forKey: "allDoneContinuity"))
    }
    
    func getCount(d: String) -> Int{
        let date = d
        let myFilter = NSPredicate(format: "date == %@", date)

//        print(realm!.objects(CompletedList.self).filter("date == \"" + date + "\""))
//        print(realm!.objects(CompletedList.self).filter(myFilter))

        if let object = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", date)).first{
            //print(object.completed.count)
            return object.completed.count
        }
        return 0
        
    }
    
    func getStatics(staticCase: Total) -> Int{
        // print("get statics")
        
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd-w"
        
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
            for item in object.reversed(){
                //print("in week", item.date)

                if item.date > weekAgo{
                    ans += item.completed.count
                }
                else{
                    break
                }
            }
            
        case .month:

            let str = "0000-00-00"
            let start = str.index(str.startIndex, offsetBy: 5)
            let end = str.index(str.endIndex, offsetBy: -3)
            for item in object{
                if Int(item.date.substring(with:start..<end)) == month{
                    ans += item.completed.count
                }
            }
        case .year:
            for item in object{
                if Int(item.date.prefix(4)) == year{
                    ans += item.completed.count
                }
            }

        case .all:
            for item in object{
                ans += item.completed.count
            }
        }
        
        return ans
    }
    
    func istodaydone(id: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str_today = dateFormatter.string(from: Date())

        if let completed = realm?.object(ofType: CompletedList.self, forPrimaryKey: str_today){
            if completed.completed.contains(id){
                return true
            }
        }
        return false

    }
    func isTodayHabitComplete() -> Int{
        var count = 0
        for item in HabitVM.shared.getTodayHabit(){
            if !istodaydone(id: item.id!){
                return -1
            }
            count += 1
        }
        return count
    }
    
    func isYesterdayHabitComplete() -> Int{
        var count = 0
        
        for item in HabitVM.shared.getYesterdayHabit(){ //어제 할 일
            if !HabitVM.shared.isDoneYesterDay(id: item.id!){ //어제 한 일
                return -1
            }
            count += 1
        }
        return count
    }
    
    func setIsToday(isToday: Bool){
        isTodayHabit = isToday

    }
    func settodayAllDone(isToday: Bool){
        self.todayAllDone = false
    }
}

//'id =
//"' + messageID + '"
//'


//let myFilter = NSPredicate(format: "title == %@", title)
//let myFilter2 = NSPredicate(format: "count == %d AND name BEGINSWITH %@", "10", "B")
//let myFilter3 = NSPredicate(format: "count ==\(count)")
//let person = realm.objects(Person.self).filter(myFilter)

enum CompleteStatus{
    case complete
    case add
    case delete
    case cancel
}
