//
//  DateFormatter.swift
//  Habit Management
//
//  Created by 남경민 on 5/21/25.
//

import Foundation

extension DateFormatter {
    static let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}
