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
    private let calendarMonthStore: StoreOf<CalendarMonthFeature>
    private let statisticsStore: StoreOf<StatisticsFeature>
    
    @EnvironmentObject var setting: Setting
    @StateObject var completedVM = compltedLIstVM.shared
    
    private var ratioSpacing: CGFloat { 3 * setting.WidthRatio }
    private var frame_size: CGFloat = CGFloat(20)
    
    @Namespace var endPoint
    
    init(calendarStore: StoreOf<CalendarFeature>, statisticsStore: StoreOf<StatisticsFeature>) {
        self.calendarStore = calendarStore
        self.calendarMonthStore = calendarStore.scope(state: \.month, action: \.month)
        self.statisticsStore = statisticsStore
    }
    
    var body: some View {
        WithViewStore(calendarStore, observe: { $0 }) { viewStore in
            CalendarBackgroundView {
                HStack(alignment: .bottom) {
                    CalendarWeekDayView()
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            VStack(alignment: .leading, spacing: 4) {
                                CalendarMonthView(store: calendarMonthStore, ratioSpacing: ratioSpacing, frame_size: frame_size)
                                
                                WithViewStore(statisticsStore, observe: { $0 }) { viewStore in
                                    HStack(alignment: .center, spacing: ratioSpacing) {
                                        YearView(
                                            store: statisticsStore,
                                            ratioSpacing: ratioSpacing,
                                            frame_size: frame_size,
                                            getColor: getColor(date:)
                                        )
                                        ThisWeekView(
                                            store: statisticsStore,
                                            ratioSpacing: ratioSpacing,
                                            frame_size: frame_size,
                                            getColor: getColor(date:)
                                        )
                                        HStack{}.id(endPoint)
                                    }
                                }
                            }
                        }
                        .onAppear() {
                            proxy.scrollTo(endPoint)
                        }
                    }
                }
                .scaledPadding(top: 12, leading: 0, bottom: 0, trailing: 25)
                
                CalendarLevelView()
            }
        }
    }
    
    func getColor(date: String) -> Color {
        let count = completedVM.getCount(d: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        
        let todayWeek = Calendar.current.dateComponents([.weekday], from: dateFormatter.date(from: date)!).weekday!
        let total = Week(rawValue: todayWeek)!.total
        
        let percent = (Double(count)/Double(total))*Double(100)
        
        if count == 0 {
            return Color(hex: "#E6E6E6")
        } else if percent < 33 {
            return Color(hex: "#D5EBD3")
        } else if percent > 33 && percent < 66 {
            return Color(hex: "#9ECAA4")
        } else {
            return Color(hex: "#36793F")
        }
    }
}
