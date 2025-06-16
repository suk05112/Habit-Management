//
//  DateFormatters.swift
//  Habit Management
//
//  Created by 서충원 on 6/16/25.
//

import Foundation

enum DateFormatters {
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
