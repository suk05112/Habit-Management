//
//  CalendarScrollView.swift
//  Habit Management
//
//  Created by 서충원 on 6/15/25.
//

import SwiftUI
import ComposableArchitecture

struct CalendarScrollView: View {
    private let calendarStore: StoreOf<CalendarFeature>
    private let calendarMonthStore: StoreOf<CalendarMonthFeature>
    private let calendarGridStore: StoreOf<CalendarGridFeature>
    private let completionStore: StoreOf<CompletionFeature>
    
    @EnvironmentObject var setting: Setting
    
    @Namespace private var scrollID
    
    init(calendarStore: StoreOf<CalendarFeature>, completionStore: StoreOf<CompletionFeature>) {
        self.calendarStore = calendarStore
        self.completionStore = completionStore
        self.calendarMonthStore = calendarStore.scope(state: \.month, action: \.month)
        self.calendarGridStore = calendarStore.scope(state: \.grid, action: \.grid)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 4) {
                    CalendarMonthView(store: calendarMonthStore)
                    HStack(alignment: .center, spacing: setting.ratioSpacing) {
                        CalendarGridView(store: calendarGridStore, completionStore: completionStore)
                    }
                }
                .id(scrollID)
            }
            .onAppear() {
                proxy.scrollTo(scrollID, anchor: .trailing)
            }
        }
    }
}
