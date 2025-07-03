//
//  StatisticsTests.swift
//  Habit Management
//
//  Created by 한수진 on 6/27/25.
//

import XCTest
import Testing
import ComposableArchitecture
import RealmSwift

@testable import Habit_Management

@MainActor
class StatisticsTests: XCTestCase {
    var realmProvider: MockRealmProvider!
    var testRealm: Realm!
    
    let mockStatisticsData = StatisticsData(
                day: [5, 10, 12, 0, 0, 3, 0],
                week: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 12, 0, 0, 3, 0],
                month: [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0],
                yearTotal: 50,
                total: 100
            )
    
    let mockFailedStatisticsData = StatisticsData(
                day: [5, 10, 12, 0, 0, 3, 0],
                week: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 12, 0, 0, 3, 0],
                month: [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0],
                yearTotal: 50,
                total: 150
            )
    
    override func setUp() {
        realmProvider = MockRealmProvider()
        testRealm = try! realmProvider.makeRealm()
    }
    
//    @Test
    func testAddOrUpdate() async {
        var realm: Realm! = try? await Realm()
//        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
//        let realm = try! await Realm(configuration: config)
        
        let statistics = realm.objects(Statistics.self).where({ $0.classification == "Todo" }).first
        
        let mockStatistics = makeMockStatistics()
        
        let store = TestStore(initialState: StatisticsFeature.State()) {
            StatisticsFeature()
        } withDependencies: {
            $0.statisticsDataClient = StatisticsClient(
                getInitialStatisticsData: {
                    return self.mockStatisticsData
                },
                    addOrUpdate: {
                        return self.mockStatisticsData
                    },
                    getStr: { selected in [] },
                    setnumOfToDoPerDay: {
                        try! realm.write {
                            let obj = realm.objects(Statistics.self).first!
                            obj.days.removeAll()
                            obj.days.append(objectsIn: [5, 10, 12, 0, 0, 3, 0])
                        }
                    },
                    setnumOfToDoPerWeek: { _, _ in },
                    setnumOfToDoPerMonth: { _, _ in },
                    getnumOfToDo: {
                        print("test getnumOfToDo")
                        return mockStatistics
                    }
                )
        }
        
        await store.send(.addOrUpdate)
        
        await store.receive(.statisticsUpdated(mockStatisticsData)) {
            $0.statisticsData = self.mockStatisticsData
            // 실패 테스트
//            $0.statisticsData = mockFailedStatisticsData
        }
        
        await store.send(.getnumOfToDo)
        await store.receive(.numOfToDoLoaded(mockStatistics)) {
            $0.todoPerDay = Array(mockStatistics.days)
            $0.todoPerWeek = Array(mockStatistics.week)
            $0.todoPerMonth = Array(mockStatistics.month)
        }

    }
    
    func makeMockStatistics() -> Statistics {
        let mock = Statistics()
        mock.year = 2025
        mock.classification = "Todo"
        
        // days
        let daysArray = [0, 0, 0, 0, 0, 0, 0]
        mock.days.append(objectsIn: daysArray)
        
        // week
        let weekArray = [Int](repeating: 0, count: 52)
        mock.week.append(objectsIn: weekArray)
        
        // month (5월에만 2)
        var monthArray = [Int](repeating: 0, count: 12)
        monthArray[4] = 2
        mock.month.append(objectsIn: monthArray)
        
        mock.total = 4
        
        return mock
    }
    
}

protocol RealmProviderProtocol {
    func makeRealm() throws -> Realm
}

class MockRealmProvider: RealmProviderProtocol {
    func makeRealm() throws -> Realm {
        return try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "testRealm"))
    }
}
