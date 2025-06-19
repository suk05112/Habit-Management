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
    
    struct DayItem: Identifiable, Equatable {
        let id = UUID()
        let date: String
    }
    
    struct State: Equatable {
        var dayItemArray: [[DayItem]] = [[]]
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.dayItemArray = generateDayItemArray()
                return .none
            }
        }
    }
}

// MARK: - Actions
extension CalendarGridFeature {
    private func generateDayItemArray() -> [[DayItem]] {
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())! // 1년 전 오늘
        var currentDate = calendar.dateInterval(of: .weekOfYear, for: oneYearAgo)!.start // 1년 전 오늘이 포함된 주의 일요일
        
        var dayItemArray = [[DayItem]]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 0..<54 {
            var weekArray = [DayItem]()
            for _ in 0..<7 {
                let date = currentDate > Date() ? "" : dateFormatter.string(from: currentDate)
                weekArray.append(DayItem(date: date))
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            dayItemArray.append(weekArray)
        }
        
        return dayItemArray
    }
}
