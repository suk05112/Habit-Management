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
    
    struct DayItem: Identifiable, Equatable, Hashable {
        let id = UUID()
        let date: String
        
        var isToday: Bool {
            guard !date.isEmpty,
                  let targetDate = DateFormatters.standard.date(from: date) else { return false }
            return Calendar.current.isDateInToday(targetDate)
        }
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
        
        for _ in 0..<54 {
            var weekArray = [DayItem]()
            for _ in 0..<7 {
                let date = currentDate > Date() ? "" : DateFormatters.standard.string(from: currentDate)
                weekArray.append(DayItem(date: date))
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            dayItemArray.append(weekArray)
            
            if let last = dayItemArray.last, last.allSatisfy({ $0.date.isEmpty }) {
                dayItemArray.removeLast()
            }
        }
        
//        dayItemArray.append(getThisWeekDayArray())
//        
        print("dayItemArray", dayItemArray)

        
        return dayItemArray
    }
    
    func getThisWeekDayArray() -> [DayItem]{
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()

        var temp: [String] = []
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(todayWeek-1)))

        //일-1, 토-7
        for _ in stride(from: 0, to: todayWeek, by: 1){
            let date = dateFormatter.string(from: startDate)
            temp.append(date)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

        }
        
        for _ in 0..<(7-todayWeek){
            temp.append("")
        }
        
        var thisWeekDayItem: [DayItem] = []
        
        temp.forEach {
            thisWeekDayItem.append(DayItem(date: $0))
        }
        
        return thisWeekDayItem        
    }
}
