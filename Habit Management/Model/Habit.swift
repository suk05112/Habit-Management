//
//  habits.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import RealmSwift

class Habit: Object, ObjectKeyIdentifiable, Identifiable {

    @Persisted(primaryKey: true) var id: String?
    @Persisted var name: String = ""
    @Persisted var weekIter: List<Int> = List<Int>()
    @Persisted var continuity: Int = 0

    var offset: CGFloat = 0.0
    var isSwipe: Bool = false
    
    var dataArray: [Int] {
            get {
                return weekIter.map{$0}
            }
            set {
                weekIter.removeAll()
                weekIter.append(objectsIn: newValue)
            }
        }
    
    convenience init(name: String, iter: [Int]) {
        self.init()
        self.name = name
        self.dataArray = iter
        self.id = DateFormatters.fullName.string(from: Date())
    }
    
    func isWeekValidate() -> Bool {
        if weekIter.isEmpty { return false }
        return true
    }
}

extension Habit {
    func weekString() -> String {
        return self.weekIter
            .map { DateFormatters.standard.shortWeekdaySymbols[($0 - 1) % 7] }
            .joined(separator: ", ")
    }
    
    func detached() -> Habit {
        let copy = Habit()
        copy.id = self.id
        copy.name = self.name
        copy.continuity = self.continuity
        copy.weekIter.append(objectsIn: self.weekIter)
        return copy
    }
}
