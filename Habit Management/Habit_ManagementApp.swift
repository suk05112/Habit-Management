//
//  Habit_ManagementApp.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
@main
struct Habit_ManagementApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
