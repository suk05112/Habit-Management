//
//  Habit_ManagementApp.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import ComposableArchitecture
import FirebaseCore
import RealmSwift
import SwiftUI
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("didfinish")

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        return true
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("didreceive")
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(
        _ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIInterfaceOrientationMask.portrait
    }
}

@main
struct HabitManagementApp: SwiftUI.App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let persistenceController = PersistenceController.shared
    private let notification = NotificationCenterManager()

    private let store: StoreOf<AppFeature>
    private let setting: Setting = Setting()

    init() {
        self.store = Store(initialState: AppFeature.State(), reducer: { AppFeature() })
        Realm.Configuration.defaultConfiguration = AppRealmSchema.makeDefaultConfiguration()
    }

    var body: some Scene {
        WindowGroup {
            MainView(store: store)
                .environmentObject(setting)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App is active")
            case .inactive:
                notification.sendNotification(seconds: 10)
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("unexpected Value")
            }
        }
    }
}
