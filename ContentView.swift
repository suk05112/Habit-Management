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


    init(){

    }
    var body: some View {
        WithPerceptionTracking {
            MainView(store: Store(
                initialState: StaticsFeature.State(),
                reducer: { StaticsFeature() }
            )
            )
            .environmentObject(setting)
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
