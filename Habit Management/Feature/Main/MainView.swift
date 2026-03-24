//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import CoreData
import ComposableArchitecture

/// `MainView`에서 실제로 그릴 때만 반응해야 하는 상태만 구독해,
/// 홈에서 습관 완료 등으로 `calendar`/`completion` 등이 바뀔 때 통계 탭 뷰가 매번 재생성되지 않게 함.
private struct MainViewObservedState: Equatable {
    var userName: String
    var hasLaunched: Bool
    var habitMode: Mode
}

struct MainView: View {
    let store: StoreOf<AppFeature>
    private let calendarStore: StoreOf<CalendarFeature>
    private let habitStore: StoreOf<HabitFeature>
    private let statisticsStore: StoreOf<StatisticsFeature>
    private let completionStore: StoreOf<CompletionFeature>
    private let reportData: ReportData
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        self.calendarStore = store.scope(state: \.calendar, action: \.calendar)
        self.habitStore = store.scope(state: \.habit, action: \.habit)
        self.statisticsStore = store.scope(state: \.statistics, action: \.statistics)
        self.completionStore = store.scope(state: \.completion, action: \.completion)
        self.reportData = ReportData(store: self.statisticsStore)
        self.store.send(.task)
    }
    
    var body: some View {
        WithViewStore(
            store,
            observe: {
                MainViewObservedState(
                    userName: $0.userName,
                    hasLaunched: $0.hasLaunched,
                    habitMode: $0.habit.mode
                )
            }
        ) { viewStore in
            ZStack {
                TabView {
                    HabitView(calendarStore: calendarStore,
                              habitStore: habitStore,
                              completionStore: completionStore)
                        .tabItem { tabIconView("house", "홈") }
                    StatisticsView(
                        calendarStore: calendarStore,
                        statisticsStore: statisticsStore,
                        completionStore: completionStore,
                        reportData: reportData
                    )
                        .tabItem { tabIconView("chart.bar.fill", "통계") }
                }
                .tint(HabitColor.defaultGreen.color)
                
                if viewStore.habitMode == .adding || viewStore.habitMode == .editing {
                    AddView(habitStore: habitStore,
                            statisticsStore: statisticsStore,
                            completionStore: completionStore)
                        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                }
                
                if !viewStore.hasLaunched {
                    OnboardingView(
                        userName: viewStore.binding(
                            get: \.userName,
                            send: { .setUserName($0) }
                        ),
                        hasLaunched: viewStore.binding(
                            get: \.hasLaunched,
                            send: { .setHasLaunched($0) }
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
    @Binding var hasLaunched: Bool
    
    var body: some View {
        FirstLaunchView(userName: $userName, hasLaunched: $hasLaunched)
            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
