//
//  GridLevelView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import SwiftUI

struct GridLevelView: View {
    private let levelHex = ["#E6E6E6", "#D5EBD3", "#9ECAA4", "#36793F"]
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            levelLabel("Less")
            level(for: levelHex)
            levelLabel("More")
        }
        .scaledPadding(top: 4, leading: 0, bottom: 12, trailing: 16)
    }
}

extension GridLevelView {
    private func levelLabel(_ text: String) -> some View {
        Text(text)
            .foregroundColor(Color.white)
            .scaledText(size: 12, weight: .semibold)
    }
    
    private func level(for colors: [String]) -> some View {
        ForEach(colors, id: \.self) { color in
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .foregroundColor(Color(hex: color))
                .scaledFrame(width: 16, height: 16, isScroll: true)
        }
    }
}
