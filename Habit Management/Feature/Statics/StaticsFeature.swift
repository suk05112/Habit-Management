//
//  StaticsFeature.swift
//  Habit Management
//
//  Created by 한수진 on 5/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StaticsFeature {
    @ObservableState
    struct State: Equatable {
        var dayArray = [[String]](repeating: Array(repeating: "",count: 7 ), count: 53)
        var monthArray: [String] = []
        var thisWeek: [String] = []
    }
  
    enum Action: Equatable {
        case onAppear
        case scrollDataLoaded(dayArray: [[String]], monthArray: [String], thisWeek: [String])
    }
            
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onAppear:
                    let data = generateScrollData()
                    return .send(.scrollDataLoaded(
                        dayArray: data.dayArray,
                        monthArray: data.monthArray,
                        thisWeek: data.thisWeek
                    ))

                case let .scrollDataLoaded(dayArray, monthArray, thisWeek):
                    state.dayArray = dayArray
                    state.monthArray = monthArray
                    state.thisWeek = thisWeek
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
                
                if dayArray[i][j].substring(from: index) == "01"{
                    //print(DayArray[i][j], " ", DayArray[i][j].substring(from: index), "1일",DayArray[i][j].substring(with:start..<end))
                    
                    month = dayArray[i][j].substring(with:start..<end)
                }
            }
            monthArray.append(month)
        }

        return (dayArray, monthArray, dayArray[52])
    }
    
}

protocol StaticsServiceProtocol {
    
}

//struct StaticsEnvironment {
//    var staticsService: StaticsServiceProtocol
//}
//
//final class StaticsServiceImpl: StaticsServiceProtocol {
//    private let realm = try! Realm()
//    
//    
//    func fetchTodayHabits() -> AnyPublisher<[Habit], Never> {
//        let todayWeek = Calendar.current.component(.weekday, from: Date())
//        let habits = realm.objects(HabitObject.self)
//            .filter { $0.weekIter.contains(todayWeek) }
//            .map { $0.toModel() }
//        
//        return Just(habits).eraseToAnyPublisher()
//    }
//    
//    func addHabit(name: String, iter: [Int]) -> Effect<HabitAction, Never> {
//        return .fireAndForget {
//            let newHabit = HabitObject(name: name, iter: iter)
//            try? self.realm.write {
//                self.realm.add(newHabit)
//            }
//        }
//    }
//}
//

