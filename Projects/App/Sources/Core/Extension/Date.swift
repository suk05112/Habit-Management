//
//  Date.swift
//  Habit Management
//
//  Created by 한수진 on 6/17/25.
//

import Foundation

extension Date {
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    func adding(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
  
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월\ndd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
}
