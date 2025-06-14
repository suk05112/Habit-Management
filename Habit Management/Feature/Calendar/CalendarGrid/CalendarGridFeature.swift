//
//  CalendarGridFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/14/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarGridFeature {
    struct State: Equatable {
        var dayArray: [[String]] = [[]]
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.dayArray = generateDayArray()
                return .none
            }
        }
    }
}

// MARK: - Actions
extension CalendarGridFeature {
    private func generateDayArray() -> [[String]] {
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())! // 1년 전 오늘
        var currentDate = calendar.dateInterval(of: .weekOfYear, for: oneYearAgo)!.start // 1년 전 오늘이 포함된 주의 일요일
        
        var dayArray = [[String]]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 0..<53 {
            var weekArray = [String]()
            for _ in 0..<7 {
                weekArray.append((currentDate > Date()) ? "" : dateFormatter.string(from: currentDate))
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            dayArray.append(weekArray)
        }
        
        return dayArray
    }
}
