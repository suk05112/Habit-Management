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
    @Published var hideCompleted: Bool
    @Published var showAll: Bool

    var isTodaydone: Bool = false
    var habit: Results<Habit>?
    var token: NotificationToken? = nil
    var realm: Realm?

    init(){

        if UserDefaults.standard.object(forKey: "showAll") == nil{
            print("show nil")
            UserDefaults.standard.set(false, forKey: "showAll")
        }
        if UserDefaults.standard.object(forKey: "hideCompleted") == nil{
            print("hide nil")
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
//                self.objectWillChange.send()
                break
            }
        })
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    

}


//get result
extension HabitVM{
    public func fetchItem(){
        print("fetchItem")

        var temp_result :[Habit]

        if showAll{
            temp_result = (NSArray(array: Array(realm!.objects(Habit.self))) as? [Habit])!
        }
        else{
            temp_result = getTodayHabit()
        }
        
        if hideCompleted{
            temp_result = temp_result.filter{!compltedLIstVM.shared.istodaydone(id: $0.id!)}
        }

        temp_result = temp_result.filter{!$0.isInvalidated}
        result = temp_result
        
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

}

//crud
extension HabitVM{
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
    
}

//continuity
extension HabitVM{
    func setContiuity(at item: Habit){
        try? realm!.write{
            if compltedLIstVM.shared.todayDoneList.completed.contains(item.id!){
                item.continuity += 1
            }else{
                item.continuity -= 1

            }
        }
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

extension HabitVM{
    
    func getArrayIter(at habit: Habit) -> [Int]{
        return Array(habit.weekIter)
    }
    
    func getNumOfTodayHabit(todayWeek: Int =  Calendar.current.dateComponents([.weekday], from: Date()).weekday!) -> Int{
//        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var count = 0
        
        realm!.objects(Habit.self).forEach{
            if $0.weekIter.contains(todayWeek){
                count += 1
            }
        }
        return count
    }
}

//setting
extension HabitVM{
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
