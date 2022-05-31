//
//  viewModel.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/18.
//

import Foundation
import RealmSwift
import SwiftUI

class HabitVM: ObservableObject {
    static let shared = HabitVM()
    let dateFormatter = DateFormatter()

    @Published var result: [Habit] = []
    var hideCompleted: Bool = false
    var isTodaydone: Bool = false
    var showAll: Bool = false

    var habit: Results<Habit>?
    var token: NotificationToken? = nil
    var realm: Realm?

    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        print("view model init")
        
        realm = try! Realm()
//        self.realm = realm
        fetchItem()


        if let group = realm?.objects(Habit.self) {
            self.habit = group

        }else {
            try! realm?.write({
                let group = Habit()
                realm?.add(group)

            })
        }
        
        token = habit?.observe({ (changes) in
            switch changes {
            case .error(_):
                print("error")
                break
    
            case .initial(_):
                print("initial")
                
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("update")
//                fetchItem()
//                self.objectWillChange.send()
                break
            }
        })
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func addItem(name: String, iter: [Int]){
        print("add item")
        if name != "", let realm = habit?.realm{
            try? realm.write{
                realm.add(Habit(name: name, iter: iter))
            }
            fetchItem()
        }
    }
    
    func deleteItem(at habit: Habit){
        print("delete")
        if realm!.objects(Habit.self).contains(habit){
            try! realm?.write {
                realm?.delete(habit)
            }
        }
        fetchItem()

    }
    
    func updateItem(name: String, iter: [Int], at item: Habit){
        print("update Item")
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
    
    public func setting(hideCompleted: Bool,showAll: Bool ){
        self.hideCompleted = hideCompleted
        self.showAll = showAll
        fetchItem()
    }
    public func fetchItem(){
        print("fetchItem")
//        getContinuity()

        var temp_result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!

        if showAll{
            temp_result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!
        }
        else{
            temp_result = getTodayHabit()
        }
        
        print("hide completed 전", hideCompleted)
        print(temp_result)
        if hideCompleted{
            temp_result = temp_result.filter{!compltedLIstVM.shared.istodaydone(id: $0.id!)}
        }
        print("hide completed 후")
        print(temp_result)
        temp_result = temp_result.filter{!$0.isInvalidated}
        result = temp_result
        
    }
    
    func getResult(habit: Habit) -> Habit{
        var myresult:[Habit] = result
        if let index = result.firstIndex(where: { $0 == habit}){
            return myresult[index]

        }
        return Habit()
    }
    
    func getTodayHabit() -> [Habit]{
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var result:[Habit] = []
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(todayWeek){
                result.append($0)
            }
        }
        return result
    }
    
    func getArrayIter(at habit: Habit) -> [Int]{
        return Array(habit.weekIter)
    }
    
    func getNumOfTodayHabit() -> Int{
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var count = 0
        
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(todayWeek){
                count += 1
            }
        }
        return count
    }
    
    func getContinuity(){
        print("in get continue")
        
        realm!.objects(Habit.self).forEach{
            let data = $0
            try! realm?.write {
                data.continuity = 0
                realm!.add(data, update: .modified)
            }
        }
        
        let completed = realm!.objects(CompletedList.self)
        completed.last?.completed.forEach{
            var count = 0
            for completedItem in completed.reversed(){
                if completedItem.completed.contains($0){
                    count += 1
                }
                else{
                    break
                }
            }
            let object = realm?.object(ofType: Habit.self, forPrimaryKey: $0)
            try! realm?.write {
                object?.continuity = count
            }
        }

    }
    
}




