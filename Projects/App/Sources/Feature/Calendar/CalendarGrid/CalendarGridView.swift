//
//  CalendarGridView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct CalendarGridView: View {
    private let store: StoreOf<CalendarGridFeature>

    @EnvironmentObject var setting: Setting
    
    @StateObject var completedVM = compltedLIstVM.shared
    
    init(store: StoreOf<CalendarGridFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let dayItemArray = viewStore.dayItemArray
            ForEach(0..<dayItemArray.count, id: \.self) { i in
                VStack(spacing: setting.ratioSpacing) {
                    ForEach(dayItemArray[i], id: \.id) { dayItem in
                        gridItem(dayItem.date)
                    }
                }
                .scaledPadding(top: 0, leading: 0, bottom: 12, trailing: 0)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    func getColor(date: String) -> Color {
        let count = completedVM.getCount(d: date)
        let today = DateFormatters.standard.date(from: date)!
        let todayWeekDay = Calendar.current.component(.weekday, from: today)
        
        let total = Week(rawValue: todayWeekDay)!.total
        
        let percent = (Double(count) / Double(total)) * Double(100)
        
        if count == 0 {
            return HabitColor.defaultGray.color
        } else if percent < 33 {
            return HabitColor.lightGreen.color
        } else if percent > 33 && percent < 66 {
            return HabitColor.mediumGreen.color
        } else {
            return HabitColor.darkGreen.color
        }
    }
}

// MARK: - UI Components
extension CalendarGridView {
    func gridItem(_ date: String) -> some View {
        RoundedRectangle(cornerRadius: setting.ratioSpacing)
            .fill(date == "" ? HabitColor.defaultGreen.color : getColor(date: date))
            .scaledFrame(width: setting.frameSize, height: setting.frameSize)
    }
}
