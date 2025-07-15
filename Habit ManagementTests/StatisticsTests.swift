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
    let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")

    let mockStatisticsData = StatisticsData(
                day: [5, 10, 12, 0, 0, 3, 0],
                week: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 12, 0, 0, 3, 0],
                month: [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0],
                yearTotal: 50,
                total: 100
            )
    
    let mockStatisticsDataForSetTest = StatisticsData(
                day: [5, 10, 12, 0, 0, 3, 10],
                week: [1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 12, 0, 0, 3, 0],
                month: [1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0],
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
        print("setup 호출")
        realmProvider = MockRealmProvider()
//        testRealm = try! realmProvider.makeRealm()

    }

//    @Test
    func testAddOrUpdate() async {
        await setInitailMockStatistics()
        
        let realm = try! await Realm(configuration: config)
        
        let mockStatistics = makeMockStatistics()
        let mockStatisticsForSetTest = makeMockStatisticsForSetTest()

        var initialState = StatisticsFeature.State()
        initialState.todoPerDay = [0, 0, 0, 0, 0, 0, 0]
        initialState.todoPerWeek = [Int](repeating: 0, count: 52)
        initialState.todoPerMonth = [0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0]

        let store = TestStore(initialState: initialState) {
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
                    let data = mockStatisticsForSetTest.days
                    try! realm.write {
                        if let obj = realm.objects(Statistics.self)
                            .where({ $0.classification == "Todo" })
                            .first {
                            obj.days.removeAll()
                            obj.days.append(objectsIn: data)
                            obj.total = 100
                        } else {
                            let newObj = Statistics()
                            newObj.days.append(objectsIn: data)
                            newObj.total = 100
                            realm.add(newObj)
                        }
                    }
                },
                setnumOfToDoPerWeek: { _, _ in
                    let data = mockStatisticsForSetTest.week
                    try? realm.write {
                        if let obj = realm.objects(Statistics.self)
                            .where({ $0.classification == "Todo" })
                            .first {
                            obj.week.removeAll()
                            obj.week.append(objectsIn: data)
                            obj.total = 100
                        } else {
                            let newObj = Statistics()
                            newObj.classification = "Todo"
                            newObj.week.append(objectsIn: data)
                            newObj.total = 100
                            realm.add(newObj)
                        }
                    }
                },
                setnumOfToDoPerMonth: { _, _ in
                    let data = mockStatisticsForSetTest.month
                    try? realm.write {
                        if let obj = realm.objects(Statistics.self)
                            .where({ $0.classification == "Todo" })
                            .first {
                            obj.month.removeAll()
                            obj.month.append(objectsIn: data)
                            obj.total = 100
                        } else {
                            let newObj = Statistics()
                            newObj.classification = "Todo"
                            newObj.month.append(objectsIn: data)
                            newObj.total = 100
                            realm.add(newObj)
                        }
                    }
                },
                getnumOfToDo: {
                    if let obj = realm.objects(Statistics.self)
                        .where({ $0.classification == "Todo" })
                        .first {
                        let stats = Statistics()
                        stats.year = obj.year
                        stats.classification = obj.classification
                        stats.days.append(objectsIn: obj.days)
                        stats.week.append(objectsIn: obj.week)
                        stats.month.append(objectsIn: obj.month)
                        stats.total = obj.total
                        
                        return stats
                        
                    } else {
                        // Realm에 없으면 빈 객체 반환
                        let emptyStats = Statistics()
                        emptyStats.classification = "Todo"
                        return emptyStats
                    }
                }
            )
        }
        
        await store.send(.addOrUpdate)
        
        await store.receive(.statisticsUpdated(mockStatisticsData)) {
            $0.statisticsData = self.mockStatisticsData
            // 실패 테스트
//            $0.statisticsData = mockFailedStatisticsData
        }
        
        // Test GetFunc
        await store.send(.getnumOfToDo)
        await store.receive(.numOfToDoLoaded(mockStatistics)) {
            $0.todoPerDay = Array(mockStatistics.days)
            $0.todoPerWeek = Array(mockStatistics.week)
            $0.todoPerMonth = Array(mockStatistics.month)
        }
        
        // Test SetFunc
        await store.send(.setnumOfToDo(add: false, numOfIter: 0))
        await store.send(.getnumOfToDo)

        await store.receive(.numOfToDoLoaded(mockStatisticsForSetTest)) {
            $0.todoPerDay = Array(mockStatisticsForSetTest.days)
            $0.todoPerWeek = Array(mockStatisticsForSetTest.week)
            $0.todoPerMonth = Array(mockStatisticsForSetTest.month)
        }
    }
    
    func setInitailMockStatistics() async {
        let current_year = 2025
        let day = [0, 0, 0, 0, 0, 0, 0]
        let week = [Int](repeating: 0, count: 52)
        var month = [Int](repeating: 0, count: 12)
        month[4] = 2
        let yearTotal = 4

        let realm = try! await Realm(configuration: config)
        
        try? realm.write({
            realm.add(Statistics(classification: "Done", year: current_year, dayArray: day, weekArray: week, monthArray: month, total: yearTotal))
            realm.add(Statistics(classification: "Todo", year: current_year, dayArray: day, weekArray: week, monthArray: month, total: yearTotal))
        })
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
    
    func makeMockStatisticsForSetTest() -> Statistics {
        let mock = Statistics()
        mock.year = 2025
        mock.classification = "Todo"
        
        // days
        let daysArray = [5, 10, 12, 0, 0, 3, 10]
        mock.days.append(objectsIn: daysArray)
        
        // week
        let weekArray = [1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 12, 0, 0, 3, 0]
        mock.week.append(objectsIn: weekArray)
        
        // month
        var monthArray = [1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0]
        mock.month.append(objectsIn: monthArray)
        
        mock.total = 100
        
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
