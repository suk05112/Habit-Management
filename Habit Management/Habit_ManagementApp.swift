//
//  Habit_ManagementApp.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import RealmSwift

@main
struct Habit_ManagementApp: SwiftUI.App {

    let persistenceController = PersistenceController.shared
    
    init(){
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 2, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: Statics.className()) { oldObject, newObject in
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
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
