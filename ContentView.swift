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
    let setting: Setting
    let store: StoreOf<AppFeature>
    
    init() {
        self.setting = Setting()
        self.store = Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    }
    
    var body: some View {
        MainView(store: store)
            .environmentObject(setting)
            .task {
                await store.send(.task).finish()
            }
    }
}
