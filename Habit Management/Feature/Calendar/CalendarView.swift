//
//  CalendarView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import SwiftUI
import ComposableArchitecture

struct CalendarView: View {
    private let calendarStore: StoreOf<CalendarFeature>
    
    @EnvironmentObject var setting: Setting
    @StateObject var completedVM = compltedLIstVM.shared
    
    init(calendarStore: StoreOf<CalendarFeature>) {
        self.calendarStore = calendarStore
    }
    
    var body: some View {
        WithViewStore(calendarStore, observe: { $0 }) { viewStore in
            CalendarBackgroundView {
                HStack(alignment: .bottom) {
                    CalendarWeekDayView()
                    CalendarScrollView(calendarStore: calendarStore)
                }
                .scaledPadding(top: 12, leading: 0, bottom: 0, trailing: 20)
                CalendarLevelView()
            }
        }
    }
}
