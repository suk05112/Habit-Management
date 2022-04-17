//
//  habits.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import RealmSwift

class Habits: Object{
    @Persisted(primaryKey: true) var id: String? = "idㅇ"
    @Persisted var name: String = "dafault name"
    @Persisted var weekIter: List<Int> = List<Int>()
    var dataArray: [Int] {
            get {
                return weekIter.map{$0}
            }
            set {
                weekIter.removeAll()
                weekIter.append(objectsIn: newValue)
            }
        }
    @Persisted var continuity: Int = 0
    
    convenience init(name: String, iter: [Int]) {
        self.init()
        self.name = name
        self.dataArray = iter
        }
}
