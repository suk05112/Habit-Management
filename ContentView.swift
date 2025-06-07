//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/15.
//

import Foundation
import SwiftUI
import UserNotifications
import ComposableArchitecture

struct ContentView: View {
    let setting = Setting()
    let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
    )

    var body: some View {

        MainView(
            store: store
        )
        .environmentObject(setting)
        .onAppear {
            print("ContentView onappear")
            let habitStore = store.scope(
                state: \.habit,
                action: AppFeature.Action.habit
            )
            habitStore.send(.onAppear)
            
            let statisticsStore = store.scope(
                state: \.statistics,
                action: AppFeature.Action.statistics
            )
            
            ReportData.configure(store: statisticsStore)
            statisticsStore.send(.onAppear)
        }
        
        /*
        switch setting.wasLaunchedBefore {
        case false: FirstLaunchView()
                .environmentObject(setting)

        case true: MainView()
                .environmentObject(setting)
                .transition(.opacity)
        }
        */
    }
    
    
    func didDismissPostCommentNotification() {
        print("함수 안!!")
    }
}
