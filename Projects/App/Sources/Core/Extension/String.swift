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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toString() -> String {
        guard let date = toDate() else { return self }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = .current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return dateFormatter.string(from: date)
    }
    
    func convert() -> String {
        guard let date = toDate() else { return self }
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale.current
        dayFormatter.timeZone = .current
        dayFormatter.dateFormat = "d"
        let day = dayFormatter.string(from: date)
        return L10n.tr("date.day_suffix", day)
    }
}
