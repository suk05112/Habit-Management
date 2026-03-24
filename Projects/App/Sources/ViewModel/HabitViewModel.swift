//
//  HabitViewModel.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/18.
//

import Foundation
import RealmSwift
import SwiftUI

class HabitViewModel: ObservableObject {
    static let shared = HabitViewModel()
    let dateFormatter = DateFormatter()

    @Published var result: [Habit] = []
    @Published var hideCompleted: Bool
    @Published var showAll: Bool

    var isTodaydone: Bool = false
    var habit: Results<Habit>?
    var token: NotificationToken? = nil
    var realm: Realm?

    init(){

        if UserDefaults.standard.object(forKey: "showAll") == nil{
            UserDefaults.standard.set(false, forKey: "showAll")
        }
        if UserDefaults.standard.object(forKey: "hideCompleted") == nil{
            UserDefaults.standard.set(false, forKey: "hideCompleted")
        }
        showAll = UserDefaults.standard.bool(forKey: "showAll")
        hideCompleted = UserDefaults.standard.bool(forKey: "hideCompleted")
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        print("view model init")
        
        realm = try! Realm()
        fetchItem()

        if let group = realm?.objects(Habit.self) {
            self.habit = group

        } else {
            try! realm?.write({
                let group = Habit()
                realm?.add(group)

            })
        }
        
        token = habit?.observe({ (changes) in
            switch changes {
            case .error(_):
                //print("error")
                break
    
            case .initial(_):
                print("initial")
                
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                //print("update")
//                self.objectWillChange.send()
                break
            }
        })
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        getNumberOfTodoPerWeek()
//        getContinuity()
    }

}


//get result
extension HabitViewModel {
    public func fetchItem(){
        print("fetchItem")

        var temp_result :[Habit]

        if showAll{
            temp_result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!
        } else{
            temp_result = getTodayHabits()
        }

        if hideCompleted {
            temp_result = temp_result.filter { !CompletedListViewModel.shared.isDoneToday(id: $0.id!) }
        }

        temp_result = temp_result.filter{!$0.isInvalidated}
        result = temp_result
        
    }
    
    func getTodayHabits() -> [Habit] {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var result:[Habit] = []
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(todayWeek){
                result.append($0)
            }
        }
        return result
    }
    
    func getYesterdayHabits() -> [Habit] {
        var yesdayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!-1
        if yesdayWeek == 0 {
            yesdayWeek = 7
        }
        var result:[Habit] = []
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(yesdayWeek){
                result.append($0)
            }
        }
        return result
    }
    
    func getWeekString(for habit: Habit) -> String {
        var str = ""
        let sorted = habit.weekIter.sorted(by: <)
        if sorted == [2, 3, 4, 5, 6] {
            str = L10n.tr("habit.week.weekdays_only")
        } else if sorted == [1, 7] {
            str = L10n.tr("habit.week.weekends_only")
        } else if sorted == [1, 2, 3, 4, 5, 6, 7] {
            str = L10n.tr("habit.week.every_day")
        } else{
            sorted.forEach{
                str += Week(rawValue: $0)!.kor
            }
        }

        return str
    }

}

//crud
extension HabitViewModel {
    func addItem(name: String, iter: [Int]){
//        print("add item")
        if name != "", let realm = habit?.realm{
            try? realm.write{
                realm.add(Habit(name: name, iter: iter))
            }
            fetchItem()
        }
    }
    
    func deleteItem(at habit: Habit){
//        print("delete")
        if realm!.objects(Habit.self).contains(habit){
            try! realm?.write {
                realm?.delete(habit)
            }
        }
        fetchItem()

    }
    
    func updateItem(name: String, iter: [Int], at item: Habit){
        //print("update Item")
        if name != "", let realm = habit?.realm{
            try? realm.write{
                item.name = name
                item.weekIter.removeAll()
                item.weekIter.append(objectsIn: iter.map{$0})
//                realm.add(Habit(name: name, iter: iter), update: .modified)
            }
            fetchItem()
        }
    }
    
}

//continuity
extension HabitViewModel {
    func setContiuity(at item: Habit) {
        try? realm!.write {
            if !isDoneYesterday(id: item.id!) {
                item.continuity = 0
            }
            if CompletedListViewModel.shared.todayDoneList.completed.contains(item.id!) {
                item.continuity += 1
            }else if item.continuity != 0{
                item.continuity -= 1

            }
        }
    }
    
    func getContinuity(){
        realm!.objects(Habit.self).forEach {
            let item = $0
            try? realm!.write {
                if !isDoneYesterday(id: item.id!) {
                    item.continuity = 0
                }
            }
        }
    }
    
    func isDoneYesterday(id: String) -> Bool {
        let yesterDayDate = Date(timeInterval: -60*60*24, since: Date())
        let yesterDay = dateFormatter.string(from: yesterDayDate)
        
        if let completedYesterDay = realm?.object(ofType: CompletedList.self, forPrimaryKey: yesterDay){
            if completedYesterDay.completed.contains(id){
                return true
            }

        }
        
        return false
    }
    
}

extension HabitViewModel {

    func getWeekIterArray(for habit: Habit) -> [Int] {
        return Array(habit.weekIter)
    }

}

//setting
extension HabitViewModel {
    func toggleHideComplete(){
        hideCompleted.toggle()
        UserDefaults.standard.set(hideCompleted, forKey: "hideCompleted")
        fetchItem()
    }
    
    func toggleShowAll(){
        showAll.toggle()
        UserDefaults.standard.set(showAll, forKey: "showAll")
        fetchItem()
    }
}

extension HabitViewModel {

    func getNumberOfTodayHabits(todayWeek: Int = Calendar.current.dateComponents([.weekday], from: Date()).weekday!) -> Int {
//        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var count = 0
        
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(todayWeek){
                count += 1
            }
        }
        return count
    }
    
    func getNumberOfTodoPerWeek() -> [Int] {
        print("여기 걸림")
        var weekTotal = [0,0,0,0,0,0,0]
        
        for item in realm!.objects(Habit.self){
            item.weekIter.forEach{
                weekTotal[$0-1] += 1
            }
        }
        
        try? realm!.write{
            realm!.objects(Statistics.self).where{($0.classification == "Todo")}.first?.dayArray = weekTotal
        }
        return weekTotal
    }
    
    func getMonthTotal() -> (Int, Int){
        let weekTotal = getNumberOfTodoPerWeek()
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")
        let nextMonth = calendar.date(byAdding: .month, value: +1, to: Date())
        let endOfMonth = calendar.date(byAdding: .day, value: -1, to:nextMonth!)
        let endOfLastMonth = calendar.date(byAdding: .day, value: -2, to:nextMonth!)

        let numOfthisMonth = calendar.dateComponents([.day,.weekday,.weekOfMonth], from: endOfMonth!).month!
        let numOflastMonth = calendar.dateComponents([.day,.weekday,.weekOfMonth], from: endOfLastMonth!).month!
        
        return (numOfthisMonth, numOflastMonth)
    }
}
