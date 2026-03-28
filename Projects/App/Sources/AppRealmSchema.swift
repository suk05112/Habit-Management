//
//  AppRealmSchema.swift
//  Habit Management
//
//  앱 기본 Realm 설정·마이그레이션 (단위 테스트에서 동일 로직 재사용)
//

import Foundation
import RealmSwift

enum AppRealmSchema {
    /// `Habit_ManagementApp` / 테스트가 같은 버전 번호를 쓰도록 한곳에 둠
    static let currentSchemaVersion: UInt64 = 6

    /// 앱 부팅 시 `Realm.Configuration.defaultConfiguration`에 넣을 설정
    static func makeDefaultConfiguration() -> Realm.Configuration {
        Realm.Configuration(
            schemaVersion: currentSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                migrate(migration: migration, oldSchemaVersion: oldSchemaVersion)
            }
        )
    }

    /// 마이그레이션 본문 — 테스트에서 `schemaVersion`만 바꿔 같은 함수를 호출
    static func migrate(migration: Migration, oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 5 {
            migration.enumerateObjects(ofType: Statistics.className()) { _, newObject in
                newObject!["year"] = 0
                newObject!["days"] = []
                newObject!["week"] = []
                newObject!["month"] = []
                newObject!["total"] = 0
                newObject!["classification"] = "Done"
            }
        }
        if oldSchemaVersion < 6 {
            var index = 0
            migration.enumerateObjects(ofType: Habit.className()) { _, newObject in
                newObject!["sortOrder"] = index
                index += 1
            }
        }
    }
}
