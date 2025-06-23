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
        
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

enum HabitColor {
    case defaultGray
    case defaultGreen
    case lightGreen
    case mediumGreen
    case darkGreen
    case blackGreen
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
        case .blackGreen:
            return Color(hex: "2E4A2B")
        }
    }
}

