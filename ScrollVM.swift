//
//  ScrollVM.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/15.
//

import Foundation
import RealmSwift
import SwiftUI

class ScrollVM: ObservableObject{
    
    static let shared = ScrollVM()
    
    var DayArray = ScrollData().DayArray
    @Published var thisWeek = ScrollData().DayArray[52]
    
//    var DayArray = [[String]](repeating: Array(repeating: "",count: 7 ), count: 53)
    var MonthArray: [String] = [" "]
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    let todayWeek = Calendar.current.dateComponents([.weekday], from: Date())

    private init(){
        print("scroll init")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        getScrollData()
//        getThisWeekDayArray()
    }

    func getScrollData(){

        //sun-1, sat-7
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(363+todayWeek.weekday!)))

        var month = " "

        for i in stride(from: 0, to: 52, by: 1){
            month = " "

            for j in stride(from: 0, to: 7, by: 1){

                DayArray[i][j] = dateFormatter.string(from: startDate)
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                
                let index = DayArray[i][j].index(DayArray[i][j].startIndex, offsetBy: 8)
                let start = DayArray[i][j].index(DayArray[i][j].startIndex, offsetBy: 5)
                let end = DayArray[i][j].index(DayArray[i][j].endIndex, offsetBy: -3)
                
                if DayArray[i][j].substring(from: index) == "01"{
                    print(DayArray[i][j], " ", DayArray[i][j].substring(from: index), "1일",DayArray[i][j].substring(with:start..<end))
                    
                    month = DayArray[i][j].substring(with:start..<end)
                }
                
            }
            MonthArray.append(month)
        }
    }

}
