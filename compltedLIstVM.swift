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

    private init(){
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let realm = try? Realm()
        self.realm = realm
//        delete()

        
        if let group = realm?.objects(CompletedList.self).first {
            self.list = group
        }else {
            
            try? realm?.write({
                let group = CompletedList()
                realm?.add(group)

            })
        }
        
//        try? realm?.write {
//            realm?.add(CompletedList(today: "2022-04-29", iter: ["2022-04-30 06:25:51", "2022-04-30 07:04:02"]), update: .modified)
//        }
    }
    
    func delete(){
        print("Delete")
        print(realm?.objects(CompletedList.self))
        let item = realm?.objects(CompletedList.self).filter(NSPredicate(format: "date = %@", "2022-04-30")).first
        try! realm?.write {
            realm?.delete(item!)
        }
        print(realm?.objects(CompletedList.self))
    }
    
    func complete(id: String){
        let today = dateFormatter.string(from: Date())
        
        let object2 = realm?.object(ofType: CompletedList.self, forPrimaryKey: today)
        print("id = ", id)
        print(object2)

        
        if let object = object2{
            if object2?.completed.contains(id) == false{
                try? realm?.write {
                    object.completed.append(id)
                }
            }
        }
        else{
            try? realm?.write {
                realm?.add(CompletedList(today: today, iter: [id]))
            }
        }
        

    }
    
    func getCount(d: String) -> Int{
        let date = d
        let myFilter = NSPredicate(format: "date == %@", date)

//        print(realm!.objects(CompletedList.self).filter("date == \"" + date + "\""))
//        print(realm!.objects(CompletedList.self).filter(myFilter))

        return realm!.objects(CompletedList.self).filter("date == \"" + date + "\"").count
    }
}

//'id =
//"' + messageID + '"
//'


//let myFilter = NSPredicate(format: "title == %@", title)
//let myFilter2 = NSPredicate(format: "count == %d AND name BEGINSWITH %@", "10", "B")
//let myFilter3 = NSPredicate(format: "count ==\(count)")
//let person = realm.objects(Person.self).filter(myFilter)
