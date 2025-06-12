//
//  scrollView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import SwiftUI
import ComposableArchitecture

struct HabitGridView: View {
    private let store: StoreOf<StatisticsFeature>
    
    @EnvironmentObject var setting: Setting
    @StateObject var completedVM = compltedLIstVM.shared
    
    private var ratioSpacing: CGFloat { 3 * setting.WidthRatio }
    private var frame_size: CGFloat = CGFloat(20)

    @Namespace var endPoint
    
    init(store: StoreOf<StatisticsFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack{
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fillColor(Color.HabitColor.primary)
                    .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                    .scaledFrame(width: .none, height: 230)
                
                VStack {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .center ,spacing: 4) {
                            ForEach(1...7, id: \.self){ i in
                                WeekView(week: i)
                            }
                        }
                        .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 3)
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {
                                VStack(alignment: .center, spacing: 4) {
                                    MonthView(
                                        store: store,
                                        ratioSpacing: ratioSpacing,
                                        frame_size: frame_size
                                    )
                                    
                                    HStack(alignment: .center, spacing: 4) {
                                        YearView(
                                            store: store,
                                            ratioSpacing: ratioSpacing,
                                            frame_size: frame_size,
                                            getColor: getColor(date:)
                                        )
                                        ThisWeekView(
                                            store: store,
                                            ratioSpacing: ratioSpacing,
                                            frame_size: frame_size,
                                            getColor: getColor(date:)
                                        )
                                        HStack{}.id(endPoint)
                                    }
                                }
                            }
                            .onAppear() {
                                proxy.scrollTo(endPoint)
                            }
                        }
                    }
                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 25)
                    
                    HStack {
                        HStack{}
                        Spacer()
                        LessMore()
                    }
                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 25)
                    
                }
                
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
