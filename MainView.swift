//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import CoreData
import RealmSwift
import Firebase
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<AppFeature>
    private let calendarStore: StoreOf<CalendarFeature>
    private let habitStore: StoreOf<HabitFeature>
    private let statisticsStore: StoreOf<StatisticsFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        self.calendarStore = store.scope(state: \.calendar, action: \.calendar)
        self.habitStore = store.scope(state: \.habit, action: \.habit)
        self.statisticsStore = store.scope(state: \.statistics, action: \.statistics)
        
        ReportData.configure(store: statisticsStore)
        self.store.send(.task)
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                TabView {
                    HabitView(calendarStore: calendarStore, habitStore: habitStore, statisticsStore: statisticsStore)
                        .tabItem { tabIconView("house", "홈") }
                    
                    StatisticsView(calendarStore: calendarStore, statisticsStore: statisticsStore)
                        .tabItem { tabIconView("chart.bar.fill", "통계") }
                }
                .tint(HabitColor.defaultGreen.color)
                if viewStore.habit.isShowingAdd {
                    AddView(habitStore: habitStore)
                        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                }
                
                if !UserDefaults.standard.bool(forKey: "wasLaunchedBefore") {
                    OnboardingView(
                        userName: viewStore.binding(
                            get: \.userName,
                            send: { .setUserName($0) }
                        )
                    )
                }
            }
            .onAppear {
                print("MainView onappear")
            }
        }
    }
}

extension MainView {
    @ViewBuilder
    func tabIconView(_ imageName: String, _ tabName: String) -> some View {
        Image(systemName: imageName)
        Text(tabName)
    }
}

struct OnboardingView: View {
    @Binding var userName: String
    
    var body: some View {
        FirstLaunchView(userName: $userName)
            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
