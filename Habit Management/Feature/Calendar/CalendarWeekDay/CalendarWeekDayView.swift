//
//  CalendarWeekDayView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI

struct CalendarWeekDayView: View {
    private let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    @EnvironmentObject var setting: Setting
    
    private var ratioSpacing: CGFloat { 3 * setting.WidthRatio }
    private var frame_size: CGFloat = CGFloat(20)
    
    var body: some View {
        week(for: days)
            .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 0)
    }
}

// MARK: - UI Components
extension CalendarWeekDayView {
    private func week(for days: [String]) -> some View {
        VStack(spacing: ratioSpacing) {
            ForEach(days, id: \.self) { day in
                Text("\(day)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .scaledFrame(width: .none, height: frame_size)
                    .foregroundColor(Color.white)
            }
        }
    }
}
