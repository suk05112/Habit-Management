//
//  GridView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
    let gridStore: StoreOf<GridFeature>
    private let statisticsStore: StoreOf<StatisticsFeature>
    
    @EnvironmentObject var setting: Setting
    @StateObject var completedVM = compltedLIstVM.shared
    
    private var ratioSpacing: CGFloat { 3 * setting.WidthRatio }
    private var frame_size: CGFloat = CGFloat(20)
    
    @Namespace var endPoint
    
    init(gridStore: StoreOf<GridFeature>, statisticsStore: StoreOf<StatisticsFeature>) {
        self.gridStore = gridStore
        self.statisticsStore = statisticsStore
    }
    
    var body: some View {
        WithViewStore(gridStore, observe: { $0 }) { viewStore in
            GridBackgroundView {
                HStack(alignment: .bottom) {
                    GridWeekDayView()
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            VStack(alignment: .leading, spacing: 4) {
                                GridMonthView(
                                    store: gridStore.scope(state: \.month, action: \.month),
                                    ratioSpacing: ratioSpacing,
                                    frame_size: frame_size
                                )
                                
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
                
                GridLevelView()
            }
        }
        .onAppear() {
            print("HabitGridView appear")
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
