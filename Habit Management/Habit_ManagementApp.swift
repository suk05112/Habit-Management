//
//  Habit_ManagementApp.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import UIKit
import UserNotifications
import PartialSheet

import RealmSwift
import FirebaseCore

import KakaoSDKCommon
import KakaoSDKAuth

import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didfinish")

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "shfqndhktnrs@naver.com") { (credentialState, error) in
          switch credentialState {
          case .authorized:
              print("autho")
            // Authorization Logic
          case .revoked, .notFound:
              print("else")
            // Not Authorization Logic
//            DispatchQueue.main.async {
//              self.window?.rootViewController?.showLoginViewController()
//            }
          default:
            break
          }
        }
        
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("didreceive")
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//            if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                return AuthController.handleOpenUrl(url: url)
//            }
//
//            return false
//        }
}

@main
struct Habit_ManagementApp: SwiftUI.App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    private var isAddViewShow = false
    
    let notification = NotificationCenterManager()

    init(){
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 5, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 5 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: Statics.className()) { oldObject, newObject in
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
        KakaoSDK.initSDK(appKey: "2d8dea59c34ee74dafeb016892e75e33")
        

        print("app ininininit")

    }
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    }
                })
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

  
