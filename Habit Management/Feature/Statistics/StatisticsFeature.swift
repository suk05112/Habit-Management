//
//  StaticsFeature.swift
//  Habit Management
//
//  Created by 한수진 on 5/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StatisticsFeature {
    struct State: Equatable {
        var dayArray = [[String]](repeating: Array(repeating: "",count: 7 ), count: 53)
        var monthArray: [String] = []
        var thisWeek: [String] = []
        var staticsData: StaticsData = StaticsData()
        var totalCounts: [Total: Int] = [:] // TotalView에 보여줄 count들을 저장
        
        // ReportData에 쓰일 변수들
        var todoPerDay: [Int] = []
        var todoPerWeek: [Int] = []
        var todoPerMonth: [Int] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case scrollDataLoaded(dayArray: [[String]], monthArray: [String], thisWeek: [String])
        case initiallizeStaticsData
        case initialStaticsDataLoaded(StaticsData)
        case computeTotalCounts
        case addOrUpdate
        case staticsUpdated(StaticsData)
        case setnumOfToDo(add: Bool, numOfIter: Int)
        case getnumOfToDo
        case numOfToDoLoaded(Statics)
    }
    
    @Dependency(\.staticsClient) var staticsClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let data = generateScrollData()
                return .merge(
                    .send(.scrollDataLoaded(
                        dayArray: data.dayArray,
                        monthArray: data.monthArray,
                        thisWeek: data.thisWeek
                    )),
                    .send(.initiallizeStaticsData),
                    .send(.getnumOfToDo),
                    .send(.computeTotalCounts)
                )

            case .addOrUpdate:
                return .run { send in
                    let data = await staticsClient.addOrUpdate()
                    await send(.staticsUpdated(data))
                }

            case let .staticsUpdated(data):
                state.staticsData = data
                return .none
                
            case let .scrollDataLoaded(dayArray, monthArray, thisWeek):
                state.dayArray = dayArray
                state.monthArray = monthArray
                state.thisWeek = thisWeek
                return .none
                
            case .initiallizeStaticsData:
                return .run { send in
                    let staticsData = await staticsClient.getInitialStaticsData()
                    await send(.initialStaticsDataLoaded(staticsData))
                }

            case let .initialStaticsDataLoaded(data):
                state.staticsData = data
                return .none
                
            case .computeTotalCounts:
                var counts: [Total: Int] = [:]
                let data = state.staticsData
                
                // 현재 요일
                let todayComps = Calendar.current.dateComponents([.year, .month, .weekday, .weekOfMonth], from: Date())
                let weekday = todayComps.weekday ?? 1
                
                // 주간 합산
                if data.day.count >= weekday {
                    let weekSlice = data.day[(7 - weekday)..<data.day.endIndex]
                    counts[.week] = weekSlice.reduce(0, +)
                }
                
                // 월간
                if data.month.count >= todayComps.month ?? 1 {
                    counts[.month] = data.month[todayComps.month! - 1]
                }
                
                // 연간, 전체
                counts[.year] = data.yearTotal
                counts[.all] = data.total
                
                state.totalCounts = counts
                return .none
                
            case .getnumOfToDo:
                return .run { send in
                    let statics = await staticsClient.getnumOfToDo()
                    await send(.numOfToDoLoaded(statics))
                }
                
            case let .numOfToDoLoaded(statics):
                state.todoPerDay = Array(statics.days)
                state.todoPerWeek = Array(statics.week)
                state.todoPerMonth = Array(statics.month)
                return .none
                
            case let .setnumOfToDo(add, numOfIter):
                staticsClient.setnumOfToDoPerDay()
                staticsClient.setnumOfToDoPerWeek(add, numOfIter)
                staticsClient.setnumOfToDoPerMonth(add, numOfIter)
                return .none
            }
            
        }
    }
    
    func generateScrollData() -> (dayArray: [[String]], monthArray: [String], thisWeek: [String]) {
        var dayArray = [[String]](repeating: Array(repeating: "", count: 7), count: 53)
        var monthArray = [" "]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let weekday = Calendar.current.dateComponents([.weekday], from: Date())
        
        //sun-1, sat-7
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(363+weekday.weekday!)))
        
        var month = " "
        
        for i in 0..<52 {
            month = " "
            
            for j in 0..<7 {
                dayArray[i][j] = dateFormatter.string(from: startDate)
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                
                let index = dayArray[i][j].index(dayArray[i][j].startIndex, offsetBy: 8)
                let start = dayArray[i][j].index(dayArray[i][j].startIndex, offsetBy: 5)
                let end = dayArray[i][j].index(dayArray[i][j].endIndex, offsetBy: -3)
                
                if dayArray[i][j][index...] == "01" {
                    month = String(dayArray[i][j][start..<end])
                }
            }
            monthArray.append(month)
        }
        
        return (dayArray, monthArray, dayArray[52])
    }
}
