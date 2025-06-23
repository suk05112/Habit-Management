//
//  WeekDayButton.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import SwiftUI

struct WeekDayButton: View {
    @State var weekOfDay: Int
    @Binding var iter: [Int]
    @State var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
            
            if iter.contains(getWeekOfDay(num: weekOfDay).rawValue) {
                iter.removeAll(where: {$0 == getWeekOfDay(num: weekOfDay).rawValue})
            } else {
                iter.append(Week(rawValue: getWeekOfDay(num: weekOfDay).rawValue)!.rawValue)
            }
            
        } label: {
            ZStack {
                Circle()
                    .fill(isSelected ? HabitColor.mediumGreen.color : .clear)
                    .scaledFrame(width: 44, height: 44)
                Text(getWeekOfDay(num:weekOfDay).description)
                    .foregroundColor(isSelected ? .white : .gray.opacity(0.5))
                    .scaledText(size: 14, weight: .medium)
            }
        }
    }

    func getWeekOfDay(num: Int) -> Week{
        return Week(rawValue: num)!
    }
}
