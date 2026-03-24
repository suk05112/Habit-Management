//
//  Color.swift
//  Habit Management
//
//  Created by 남경민 on 5/21/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red: Double = Double((int >> 16) & 0xFF) / 255
        let green: Double = Double((int >> 8) & 0xFF) / 255
        let blue: Double = Double(int & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

enum HabitColor {
    case defaultGray
    case defaultGreen
    case lightGreen
    case mediumGreen
    case darkGreen
}

extension HabitColor {
    var color: Color {
        switch self {
        case .defaultGray:
            return Color(hex: "E6E6E6")
        case .defaultGreen:
            return Color(hex: "639F70")
        case .lightGreen:
            return Color(hex: "D5EBD3")
        case .mediumGreen:
            return Color(hex: "9ECAA4")
        case .darkGreen:
            return Color(hex: "36793F")
        }
    }
}

