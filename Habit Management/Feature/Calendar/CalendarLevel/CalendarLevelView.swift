//
//  CalendarLevelView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import SwiftUI

struct CalendarLevelView: View {
    private let HabitLevel: [HabitColor] = [.defaultGray, .lightGreen, .mediumGreen, .darkGreen]
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            levelLabel("LEVEL")
            level(for: HabitLevel)
        }
        .scaledPadding(top: 0, leading: 0, bottom: 12, trailing: 20)
    }
}

// MARK: - UI Components
extension CalendarLevelView {
    private func levelLabel(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Color.white)
            .scaledText(size: 12, weight: .bold)
    }
    
    private func level(for colors: [HabitColor]) -> some View {
        HStack(spacing: 3) {
            ForEach(colors, id: \.self) { color in
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .foregroundColor(color.color)
                    .scaledFrame(width: 12, height: 12, isScroll: true)
            }
        }
    }
}
