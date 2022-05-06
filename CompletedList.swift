//
//  CompletedList.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import RealmSwift

class CompletedList: Object{
    @Persisted var date: String
    @Persisted var completed: List<String> = List<String>()
    
    var dataArray: [String] {
            get {
                return completed.map{$0}
            }
            set {
                completed.removeAll()
                completed.append(objectsIn: newValue)
//                completed.append(objectsIn: Array(Set(newValue)))

            }
        }

    convenience init(today: String, iter: [String]) {
        self.init()
        self.date = today
        self.dataArray = iter
        }
    
    override class func primaryKey() -> String? {
        return "date"
        
    }

    
}
