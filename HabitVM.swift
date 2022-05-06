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
    
//    @Published var habit: Habits? = nil
//    @Published var result: [Habits]? = nil
    
    let dateFormatter = DateFormatter()

    @Published var result: [Habit] = []
    
    var habit: Results<Habit>?
    var token: NotificationToken? = nil

    var realm: Realm?

    init(){
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        print("view model init")
        
        let realm = try? Realm()
        self.realm = realm
        fetchItem()

        if let group = realm?.objects(Habit.self) {
            self.habit = group
//            self.todayHabit = getTodayHabit(i: 3)

        }else {
            
            try? realm?.write({
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
//                self.objectWillChange.send()

            }
        })
        
        getContinuity()
        print("result =", result)
        print(Realm.Configuration.defaultConfiguration.fileURL!)

    }
    
    func addItem(name: String, iter: [Int]){
        
        if name != "", let realm = habit?.realm{
            try? realm.write{
                realm.add(Habit(name: name, iter: iter))
                fetchItem()
            }
        }

    }
    
    func deleteItem(at habit: Habit){
        try! realm?.write {
            realm?.delete(habit)
            fetchItem()
        }
    }
    
    public func fetchItem(){
        result = getTodayHabit()!
//        result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!

    }
    
    func getTodayHabit() -> [Habit]?{
        var todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!

        //나중에 지우기
        todayWeek = 3
        let todayHabit = Array(realm!.objects(Habit.self)).filter{ $0.weekIter.contains(todayWeek)}
        
//        print("filtered list= ", filteredList)
        
        return todayHabit
    }
    
    func getContinuity(){
        
        print("in get continue")
        
        realm!.objects(Habit.self).forEach{
            var day = dateFormatter.string(from: Date())
            let data = $0

            try! realm?.write {
                data.continuity = 0
                realm!.add(data, update: .modified)
            }
            
            for completedItem in realm!.objects(CompletedList.self).sorted(by: {$0.date>$1.date}){

                if completedItem.date != day || completedItem.completed.contains($0.id!) == false {

                    print("날짜 연속되지 않음")
                    return
                }
                else{
                    try! realm?.write {
                        data.continuity += 1
                        realm!.add(data, update: .modified)
                    }
                     
                }
                
                day = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: day)!)!)

            }

        }
    }
    
}
