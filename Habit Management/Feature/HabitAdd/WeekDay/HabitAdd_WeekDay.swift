//
//  HabitAdd_WeekDay.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import SwiftUI
import ComposableArchitecture

extension HabitAddView {
    struct WeekDayView: View {
        
        let habitStore: StoreOf<HabitFeature>
        
        var body: some View {
            WithViewStore(habitStore, observe: { $0 }) { viewStore in
                HStack {
                    ForEach(1...7, id: \.self) { index in
                        WeekDayButton(weekOfDay: index, iter: viewStore.binding(
                            get: \.iter,
                            send: HabitFeature.Action.setIter
                        ), isSelected: viewStore.selectedHabit?.weekIter.contains(index) ?? false ? true : false)
                        if index != 7 {
                            Spacer()
                        }
                    }
                }
                .scaledPadding(top: 12, leading: 20, bottom: 0, trailing: 20)
            }
        }
    }
}

struct WeekDayButton: View {
    @State var weekOfDay: Int
    @Binding var iter: [Int]
    @State var isSelected: Bool
    
    private let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        Button {
            isSelected.toggle()
            
            if iter.contains(getWeekOfDay(num: weekOfDay).rawValue) {
                iter.removeAll(where: {$0 == getWeekOfDay(num: weekOfDay).rawValue})
            } else {
                iter.append(Week(rawValue: getWeekOfDay(num: weekOfDay).rawValue)!.rawValue)
            }
        } label: {
            Text(getWeekOfDay(num:weekOfDay).description)
                .foregroundColor(isSelected ? .white : .gray.opacity(0.4))
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .background(Circle().fill(isSelected ? HabitColor.mediumGreen.color : .clear).frame(width: 44, height: 44))
                .scaledFrame(width: 44, height: 44)
        }
    }
    
    func getWeekOfDay(num: Int) -> Week {
        return Week(rawValue: num)!
    }
}
