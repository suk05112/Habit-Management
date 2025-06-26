//
//  String.swift
//  Habit Management
//
//  Created by 한수진 on 6/17/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월\ndd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self.toDate()!)
    }
    
    func convert() -> String{
        let monthFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.locale = Locale(identifier: "ko_KR")

        monthFormatter.timeZone = TimeZone(abbreviation: "KST")
        dayFormatter.timeZone = TimeZone(abbreviation: "KST")

        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        
        let month = Int(monthFormatter.string(from: self.toDate()!))!
        let day = dayFormatter.string(from: self.toDate()!)

//        return "\(Month(rawValue: month)!.description)\n\(day)"
        return "\(day)일"

    }
}
