//
//  StatisticsTests.swift
//  Habit Management
//
//  Created by 한수진 on 6/27/25.
//

import Testing
import ComposableArchitecture
import RealmSwift

@testable import Habit_Management

@MainActor
class StatisticsTests {
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
    @Test
    func testAddOrUpdate() async {
        let mockStatistics = makeMockStatistics()
        
        let store = TestStore(initialState: StatisticsFeature.State(), reducer: StatisticsFeature.init) {
            $0.statisticsDataClient.addOrUpdate = {
                return self.mockStatisticsData
            }
            
            $0.statisticsDataClient.getInitialStatisticsData = { [self] in
                return mockStatisticsData
            }
            
            $0.statisticsDataClient.getnumOfToDo = {
                return mockStatistics
            }
            
//            $0.statisticsDataClient.setnumOfToDoPerDay = {}
//            $0.statisticsDataClient.setnumOfToDoPerWeek = { _, _ in }
//            $0.statisticsDataClient.setnumOfToDoPerMonth = { _, _ in }
        }
        
        await store.send(.addOrUpdate)
        
        await store.receive(.statisticsUpdated(mockStatisticsData)) {
            $0.statisticsData = self.mockStatisticsData
            // 실패 테스트
//            $0.statisticsData = mockFailedStatisticsData
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
