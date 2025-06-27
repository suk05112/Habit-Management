//
//  Statistics.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/11.
//

import Foundation
import RealmSwift

class Statistics: Object {
    //    @Persisted(primaryKey: true) var year: Int = 0
    @Persisted var year: Int = 0
    @Persisted var days: List<Int> = List<Int>()
    @Persisted var week: List<Int> = List<Int>()
    @Persisted var month: List<Int> = List<Int>()
    @Persisted var total: Int
    @Persisted var classification: String
    
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
    
    convenience init(classification: String, year: Int, dayArray: [Int], weekArray: [Int], monthArray: [Int], total: Int) {
        self.init()
        
        self.classification = classification
        self.year = year
        self.dayArray = dayArray
        self.weekArray = weekArray
        self.monthArray = monthArray
        self.total = total
    }
}

/// Statistics
/// Statistics {
/*
 year = 2025;
 days = List<int> <0x12e8ede40> (
 [0] 3,
 [1] 1,
 [2] 0,
 [3] 2,
 [4] 0,
 [5] 1,
 [6] 1
 );
 week = List<int> <0x12e8ede80> (
 [0] 0,
 [1] 0,
 [2] 0,
 [3] 0,
 [4] 0,
 [5] 0,
 [6] 0,
 [7] 0,
 [8] 0,
 [9] 0,
 [10] 0,
 [11] 0,
 [12] 0,
 [13] 0,
 [14] 0,
 [15] 0,
 [16] 0,
 [17] 0,
 [18] 0,
 [19] 0,
 [20] 0,
 [21] 0,
 [22] 0,
 [23] 0,
 [24] 0,
 [25] 0,
 [26] 0,
 [27] 0,
 [28] 0,
 [29] 0,
 [30] 0,
 [31] 0,
 [32] 0,
 [33] 0,
 [34] 0,
 [35] 0,
 [36] 0,
 [37] 0,
 [38] 0,
 [39] 0,
 [40] 0,
 [41] 0,
 [42] 0,
 [43] 0,
 [44] 0,
 [45] 0,
 [46] 0,
 [47] 0,
 [48] 0,
 [49] 0,
 [50] 0,
 [51] 0
 );
 month = List<int> <0x12e8edec0> (
 [0] 0,
 [1] 0,
 [2] 0,
 [3] 0,
 [4] 2,
 [5] 0,
 [6] 0,
 [7] 0,
 [8] 0,
 [9] 0,
 [10] 0,
 [11] 0
 );
 total = 2;
 classification = Todo;
 */
