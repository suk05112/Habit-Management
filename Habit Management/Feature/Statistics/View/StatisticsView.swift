//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 5/23/25.
//

import SwiftUI
import ComposableArchitecture

struct StatisticsView: View {
    let calendarStore: StoreOf<CalendarFeature>
    let statisticsStore: StoreOf<StatisticsFeature>
    
    @State var ratio: Double = Double(5/6)
    @StateObject var completedVM = compltedLIstVM.shared
    
    @State private var showingDetail = false
    
    @State var index: Int = 0
    @State var randomText: (String, String, String) = ("", "", "")
    
    init(calendarStore: StoreOf<CalendarFeature>, statisticsStore: StoreOf<StatisticsFeature>) {
        print("StaticsView init")
        self.calendarStore = calendarStore
        self.statisticsStore = statisticsStore
        ReportData.configure(store: statisticsStore)
        randomText = ReportData.shared.getRandomText()
    }
    
    var body: some View {
        WithViewStore(statisticsStore, observe: { $0 }) { viewStore in
            ZStack{
                VStack{
                    HStack{
                        Text("Statistics")
                            .scaledText(size: 30, weight: .semibold)
                        Spacer()
                        
                    }
                    .scaledPadding(top: 10, leading: 20, bottom: 5, trailing: 15)
                    
                    CalendarView(calendarStore: calendarStore)
                    
                    ReportView(str: $randomText.0, percentHead: $randomText.1, percent: $randomText.2)
                        .sheet(isPresented: $showingDetail){
                            ReportListView()
                        }
                        .onTapGesture {
                            showingDetail = true
                        }
                        .scaledPadding(top: 10, leading: 0, bottom: 0, trailing: 0)
                    
                    Spacer()
                    Graph(store: statisticsStore, ratio: 1)
                    Spacer()
                    HStack{
                        TotalView(staticCase: .week, store: statisticsStore)
                        TotalView(staticCase: .month, store: statisticsStore)
                        TotalView(staticCase: .year, store: statisticsStore)
                        TotalView(staticCase: .all, store: statisticsStore)
                    }
                    .scaledPadding(top: 0, leading: 0, bottom: 30, trailing: 0)
                }
            }.onAppear {
                print("StaticsView onappear")
                viewStore.send(.onAppear)
                ReportData.shared.setReportText()
                randomText = ReportData.shared.getRandomText()
            }
        }
    }
}
