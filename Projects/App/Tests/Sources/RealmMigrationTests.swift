//
//  RealmMigrationTests.swift
//  Habit ManagementTests
//
//  v5 Realm 파일을 만든 뒤 v6 설정으로 열어 마이그레이션이 크래시 없이
//  sortOrder를 기대대로 채우는지 검증합니다.
//

import XCTest
import RealmSwift
@testable import Habit_Management

final class RealmMigrationTests: XCTestCase {

    /// 임시 파일 URL — 테스트마다 고유 경로로 병렬 실행 시 충돌 방지
    private func uniqueRealmURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("realm-migration-test-\(UUID().uuidString).realm")
    }

    func testMigrationFromV5ToV6_assignsDistinctSortOrders() throws {
        let url = uniqueRealmURL()
        defer { try? FileManager.default.removeItem(at: url) }

        // 1) 스키마 버전 5로 새 DB 생성 (앱 코드의 Habit에는 이미 sortOrder 컬럼이 있음)
        let configV5 = Realm.Configuration(fileURL: url, schemaVersion: 5)
        try autoreleasepool {
            let realm = try Realm(configuration: configV5)
            try realm.write {
                for i in 0..<3 {
                    let h = Habit()
                    h.id = "migration-test-habit-\(i)"
                    h.name = "H\(i)"
                    h.weekIter.append(objectsIn: [1, 2])
                    h.continuity = 0
                    h.sortOrder = 0
                    realm.add(h)
                }
            }
        }

        // 2) 앱과 동일한 schemaVersion·migrationBlock으로 재오픈 → v5→v6 마이그레이션 실행
        let configV6 = Realm.Configuration(
            fileURL: url,
            schemaVersion: AppRealmSchema.currentSchemaVersion,
            migrationBlock: { migration, old in
                AppRealmSchema.migrate(migration: migration, oldSchemaVersion: old)
            }
        )

        let realmV6 = try Realm(configuration: configV6)
        let habits = realmV6.objects(Habit.self)
        XCTAssertEqual(habits.count, 3, "마이그레이션 후에도 습관 3개가 유지되어야 함")

        let orders = habits.map(\.sortOrder)
        XCTAssertEqual(Set(orders), [0, 1, 2], "열거 순서대로 sortOrder 0,1,2가 한 번씩 배정되어야 함")
    }

    /// 메모리 Realm + 최신 스키마만 열리는지 (기본 설정과 동일 블록)
    func testInMemoryRealmWithAppConfigurationOpens() throws {
        let id = "realm-inmem-\(UUID().uuidString)"
        var config = AppRealmSchema.makeDefaultConfiguration()
        config.inMemoryIdentifier = id
        config.fileURL = nil

        let realm = try Realm(configuration: config)
        XCTAssertEqual(realm.objects(Habit.self).count, 0)
    }
}
