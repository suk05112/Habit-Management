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
    private let completionStore: StoreOf<CompletionFeature>

    @EnvironmentObject var setting: Setting
    
    @StateObject var completedListViewModel = CompletedListViewModel.shared
    
    init(store: StoreOf<CalendarGridFeature>, completionStore: StoreOf<CompletionFeature>) {
        self.store = store
        self.completionStore = completionStore
    }
    
    var body: some View {
        WithViewStore(completionStore, observe: { $0 }) { completionViewStore in
            WithViewStore(store, observe: { $0 }) { viewStore in
                let dayItemArray = viewStore.dayItemArray
                ForEach(dayItemArray, id: \.self) { week in
                    VStack(spacing: setting.ratioSpacing) {
                        ForEach(week, id: \.id) { dayItem in
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
    }
    
    func getColor(date: String, todayCount: Int) -> Color {
        var count = completedListViewModel.getCount(date: date)

        guard let targetDate = DateFormatters.standard.date(from: date) else {
            return HabitColor.defaultGray.color
        }
            
        if Calendar.current.isDateInToday(targetDate) {
            count = todayCount
        }
        
        let today = DateFormatters.standard.date(from: date)!
        let todayWeekDay = Calendar.current.component(.weekday, from: today)
        
        let total = Week(rawValue: todayWeekDay)!.total
        
        let percent = (Double(count) / Double(total)) * Double(100)
        
        print("date", date, "todayCount", todayCount, percent)
        if count == 0 {
            print("1")
            return HabitColor.defaultGray.color
        } else if percent < 33 {
            print("2")
            return HabitColor.lightGreen.color
        } else if percent > 33 && percent < 66 {
            print("3")

            return HabitColor.mediumGreen.color
        } else {
            print("4")

            return HabitColor.darkGreen.color
        }
    }
}

// MARK: - UI Components
extension CalendarGridView {
    func gridItem(_ date: String) -> some View {
        return WithViewStore(completionStore, observe: { $0 }) { completionViewStore in
            RoundedRectangle(cornerRadius: setting.ratioSpacing)
                .fill(date == "" ? HabitColor.defaultGreen.color : getColor(date: date, todayCount: completionViewStore.todayCount))
                .scaledFrame(width: setting.frameSize, height: setting.frameSize)
        }

//        return RoundedRectangle(cornerRadius: setting.ratioSpacing)
//            .fill(date == "" ? HabitColor.defaultGreen.color : getColor(date: date, todayCount: 1))
//            .scaledFrame(width: setting.frameSize, height: setting.frameSize)
    }
}

