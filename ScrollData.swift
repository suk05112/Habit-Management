//
//  ScrollData.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/24.
//

import Foundation
import SwiftUI

class ScrollData {
    let dateFormatter = DateFormatter()
    
    var MonthArray: [String] = []
    var DayArray = [[String]](repeating: Array(repeating: "",count: 7 ), count: 53)

    init(){
        let calendar = Calendar.current
        let todayWeek = calendar.dateComponents([.weekday], from: Date())
        //sun-1, sat-7
        var startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(363+todayWeek.weekday!)))

        dateFormatter.dateFormat = "yyyy-MM-dd"
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
            MonthArray.append( month)
        }
        
        startDate = Date(timeIntervalSinceNow: TimeInterval(-3600*24*(todayWeek.weekday!-1)))
        
        month = " "

        for i in stride(from: 0, to: todayWeek.weekday!, by: 1){
            DayArray[52][i] = dateFormatter.string(from: startDate)
            let str = DayArray[52][i]
            
//            일 구하기
//            let start = str.index(str.endIndex, offsetBy: -2)
//            let end = str.endIndex
//            let range = start..<end
            
            //월 구하기
            let start = str.index(str.startIndex, offsetBy: 5)
            let end = str.index(str.endIndex, offsetBy: -3)
            
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            if str != "", str.substring(with:start..<end) == "01"{
                month = str.substring(with:start..<end)
            }
            
        }
        MonthArray.append( month)

//            print(DayArray)
//            print(MonthArray)
        
    }
    

}
