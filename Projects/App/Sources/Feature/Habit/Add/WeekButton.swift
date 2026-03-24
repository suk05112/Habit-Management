//
//  WeekButton.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import Foundation
import SwiftUI

struct WeekButton: View {
    @State var weekOfDay: Int
    @Binding var iter: [Int]
    @State var onOff: Bool

    var body: some View {
        Button(action: {
            onOff.toggle()
            if iter.contains(getWeekOfDay(num: weekOfDay).rawValue) {
                iter.removeAll(where: { $0 == getWeekOfDay(num: weekOfDay).rawValue })
            } else {
                iter.append(Week(rawValue: getWeekOfDay(num: weekOfDay).rawValue)!.rawValue)
            }

        }) {
            ZStack {
                Circle()
                    .fill(onOff ? Color(hex: "#639F70") : Color.white)
                    .scaledFrame(width: 41, height: 41)
                Text(getWeekOfDay(num: weekOfDay).description).foregroundColor(Color.black)
                    .scaledText(size: 14, weight: .none)
            }
        }
    }

    func getWeekOfDay(num: Int) -> Week {
        Week(rawValue: num)!
    }
}
