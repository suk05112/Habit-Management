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
    
//    private let habitStore: StoreOf<HabitFeature>
//    private let statisticsStore: StoreOf<StaticsFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
//        self.habitStore = store.scope(state: \.habit, action: \.habit)
//        self.statisticsStore = store.scope(state: \.statistics, action: \.statistics)
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                TabView {
                    HabitView(habitStore: store.scope(state: \.habit, action: \.habit), statisticsStore: store.scope(state: \.statistics, action: \.statistics))
                        .tabItem {
                            Image(systemName: "house")
                            Text("홈")
                        }
                    
                    StaticsView(store: store.scope(state: \.statistics, action: \.statistics))
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("통계")
                        }
                }
                if viewStore.habit.isShowingAdd {
                    AddView(habitStore: store.scope(state: \.habit, action: \.habit))
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
                ReportData.configure(store: store.scope(state: \.statistics, action: \.statistics))
                print("🐨\(viewStore.userName)")
//                habitStore.send(.onAppear)
            }
        }
    }
}

struct OnboardingView: View {
    @Binding var userName: String
    
    var body: some View {
        FirstLaunchView(userName: $userName)
            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
