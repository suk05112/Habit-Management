//
//  Date.swift
//  Habit Management
//
//  Created by 서충원 on 6/16/25.
//

import Foundation

extension Date {
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    func adding(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
