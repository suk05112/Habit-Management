//
//  GridWeekDayView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI

struct GridWeekDayView: View {
    private let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        week(for: days)
            .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 0)
    }
}

extension GridWeekDayView {
    private func week(for days: [String]) -> some View {
        VStack(spacing: 3) {
            ForEach(days, id: \.self) { day in
                Text("\(day)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .scaledFrame(width: .none, height: 20)
                    .foregroundColor(Color.white)
            }
        }
    }
}
