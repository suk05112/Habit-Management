//
//  scrollView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HabitGridView: View {
    let store: StoreOf<StaticsFeature>
    
    @StateObject var completedVM = compltedLIstVM.shared
    @EnvironmentObject var setting: Setting
    @State var frame_size: CGFloat = CGFloat(20)

    @Namespace var endPoint
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15*setting.WidthRatio, style: .continuous)
                .fill(Color(hex: "#639F70"))
                .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                .scaledFrame(width: .none, height: 230)
            
            VStack{
                HStack(alignment: .bottom){
                    VStack(alignment: .center ,spacing:3*setting.WidthRatio){
                        ForEach(1...7, id: \.self){ i in
                            WeekView(week: i)
                        }
                    }
                    .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 3)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            VStack(alignment: .center, spacing: 3*setting.WidthRatio){
                                MonthView(store: store, frame_size: $frame_size)
                                
                                HStack(alignment: .center, spacing: 3*setting.WidthRatio) {
                                    YearView(store: store, frame_size: $frame_size, getColor: getColor(date:))
                                    ThisWeekView(frame_size: $frame_size, getColor: getColor(date:))
                                    HStack{}.id(endPoint)
                                }
                            }
                        }
                        .onAppear(){
                            proxy.scrollTo(endPoint)
                        }
                    }
                }
                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 25)

                HStack{
                    HStack{}
                    Spacer()
                    LessMore()
                }
                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 25)

            }

        }
        .onAppear() {
            print("HabitGridView appear")
        }
    }
    
    func getColor(date: String) -> Color{
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
