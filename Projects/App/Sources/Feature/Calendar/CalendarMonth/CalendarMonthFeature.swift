//
//  CalendarMonthFeature.swift
//  Habit Management
//
//  Created by 서충원 on 6/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarMonthFeature {
    
    struct MonthItem: Identifiable, Equatable {
        let id = UUID()
        let month: String
    }
    
    struct State: Equatable {
        var monthItemArray: [MonthItem] = []
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.monthItemArray = generateMonthItemArray()
                return .none
            }
        }
    }
}

// MARK: - Actions
extension CalendarMonthFeature {
    private func generateMonthItemArray() -> [MonthItem] {
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())! // 1년 전 오늘
        var currentDate = calendar.dateInterval(of: .weekOfYear, for: oneYearAgo)!.start // 1년 전 오늘이 포함된 주의 일요일
        
        var monthArray = [MonthItem]()
        var lastMonth = -1
        
        for _ in 0..<52 {
            let month = calendar.component(.month, from: currentDate)
            monthArray.append(month != lastMonth ? MonthItem(month: String(format: "%02d", month)) : MonthItem(month: " "))
            lastMonth = month
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        }
        
        return monthArray
    }
}

