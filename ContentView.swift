//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/15.
//

import SwiftUI
import UserNotifications
import ComposableArchitecture

struct ContentView: View {
    @State private var store: StoreOf<AppFeature>
    @StateObject private var setting = Setting()
    
    private let habitStore: StoreOf<HabitFeature>
    private let statisticsStore: StoreOf<StaticsFeature>
    
    init() {
        let initalStore = Store(initialState: AppFeature.State(), reducer: { AppFeature() })
        _store = State(initialValue: initalStore)
        
        self.habitStore = initalStore.scope(state: \.habit, action: \.habit)
        self.statisticsStore = initalStore.scope(state: \.statistics, action: \.statistics)
    }
    
    var body: some View {
        MainView(store: store)
            .environmentObject(setting)
            .task {
                print("ContentView onappear")
                habitStore.send(.onAppear)
                ReportData.configure(store: statisticsStore)
                statisticsStore.send(.onAppear)
            }
    }
}
