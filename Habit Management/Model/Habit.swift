//
//  habits.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.l
//

import Foundation
import RealmSwift

class Habit: Object, Identifiable, ObjectKeyIdentifiable{
    
    let dateFormatter = DateFormatter()

    @Persisted(primaryKey: true) var id: String?
    @Persisted var name: String = ""
    @Persisted var weekIter: List<Int> = List<Int>()
    @Persisted var continuity: Int = 0

    var offset:CGFloat = 0.0
    var isSwipe:Bool = false
    
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
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//        print("date = ", dateFormatter.string(from: Date()))
        self.id = dateFormatter.string(from: Date())
        }
    
    func isWeekValidate() -> Bool {
        if weekIter.isEmpty { return false }
        return true
    }
}
