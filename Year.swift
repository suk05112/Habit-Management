//
//  Year.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/11.
//

import Foundation
import RealmSwift
class Year: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    @Persisted var days: List<Int> = List<Int>()
    @Persisted var week: List<Int> = List<Int>()
    @Persisted var month: List<Int> = List<Int>()
//    @Persisted var total: Int


//    var parentCategory = LinkingObjects(fromType: Statics.self, property: "items")
    
    var dayArray: [Int] {
            get {
                return days.map{$0}
            }
            set {
                days.removeAll()
                days.append(objectsIn: newValue)
            }
        }
    
    var weekArray: [Int] {
            get {
                return week.map{$0}
            }
            set {
                week.removeAll()
                week.append(objectsIn: newValue)
            }
        }
    
    var monthArray: [Int] {
            get {
                return month.map{$0}
            }
            set {
                month.removeAll()
                month.append(objectsIn: newValue)
            }
        }
    
    convenience init(dayArray: [Int], weekArray: [Int], monthArray: [Int]){
        self.init()

        self.dayArray = dayArray
        self.weekArray = weekArray
        self.monthArray = monthArray
    }
    
//    convenience init(name: String, iter: [Int]) {
//    }
    
}

