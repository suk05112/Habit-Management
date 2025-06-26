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
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        //        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        return true
    }

    func application(
        _ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("didreceive")
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)

    }
    func application(
        _ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
}

@main
struct Habit_ManagementApp: SwiftUI.App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let persistenceController = PersistenceController.shared
    private let notification = NotificationCenterManager()

    private let store: StoreOf<AppFeature>
    private let setting: Setting = Setting()

    init() {
        self.store = Store(initialState: AppFeature.State(), reducer: { AppFeature() })
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 5,  // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 5 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: Statistics.className()) {
                        oldObject, newObject in
                        newObject!["year"] = 0
                        newObject!["days"] = []
                        newObject!["week"] = []
                        newObject!["month"] = []
                        newObject!["total"] = 0
                        newObject!["classification"] = "Done"
                    }
                }
            }
        )

        // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
        Realm.Configuration.defaultConfiguration = config
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
