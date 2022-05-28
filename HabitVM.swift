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
//                print("update")
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
    
    func updateItem(name: String, iter: [Int], at item: Habit){
        print("update Item")
        if name != "", let realm = habit?.realm{
            try? realm.write{
                item.name = name
                item.weekIter.removeAll()
                item.weekIter.append(objectsIn: iter.map{$0})
//                realm.add(Habit(name: name, iter: iter), update: .modified)
                fetchItem()
            }

        }
    }
    public func fetchItem(){
        print("fetchItem")
//        result = getTodayHabit()!
        result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!
        getContinuity()

    }
    
    func getArrayIter(at habit: Habit) -> [Int]{
        return Array(habit.weekIter)
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




