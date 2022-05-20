//
//  Statics.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/11.
//

import Foundation
import RealmSwift

class Statics: Object {
    
    @Persisted(primaryKey: true) var year: Int
    @Persisted var days: List<Int> = List<Int>()
    @Persisted var week: List<Int> = List<Int>()
    @Persisted var month: List<Int> = List<Int>()
    @Persisted var total: Int
    
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
    
    convenience init(year: Int, dayArray: [Int], weekArray: [Int], monthArray: [Int], total: Int){
        self.init()

        self.year = year
        self.dayArray = dayArray
        self.weekArray = weekArray
        self.monthArray = monthArray
        self.total = total
    }
    
    
}


