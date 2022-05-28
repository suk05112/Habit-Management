//
//  Habit_ManagementApp.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import UIKit
import RealmSwift
import PartialSheet

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("my code~~~")
        return true
        
    }
}

@main
struct Habit_ManagementApp: SwiftUI.App {

    let persistenceController = PersistenceController.shared
    private var isAddViewShow = false
    
    init(){
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 3, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: Statics.className()) { oldObject, newObject in
                        newObject!["year"] = []
                        newObject!["days"] = []
                        newObject!["week"] = []
                        newObject!["month"] = []
                        newObject!["total"] = 0

                    }
                }
            }
        )
        
        // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
        Realm.Configuration.defaultConfiguration = config
    }
    var body: some Scene {
        let setting = Setting()
        
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(setting)
        }
        
    }
    
    func checkUserDefault(){
        
    }
}

  
