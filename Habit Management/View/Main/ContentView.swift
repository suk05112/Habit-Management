//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/15.
//

import Foundation
import SwiftUI
import UserNotifications

struct ContentView: View {
    let setting = Setting()


    init(){

    }
    var body: some View {
        MainView()
            .environmentObject(setting)
           
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
