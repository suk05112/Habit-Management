//
//  habits.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import RealmSwift

class Habits: Object{
    @Persisted(primaryKey: true) var id: String? = "id"
    @Persisted var name: String = "dafault name"
//    @Persisted weekIter:Iter
    @Persisted var continuity: Int = 0
    
    convenience init(name: String) {
            self.init()
            self.name = name
        }
}
