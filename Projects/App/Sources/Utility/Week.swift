//
//  Week.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation

enum Week: Int{
    case sun = 1, mon, tue, wed, thu, fri, sat
    
    var description : String {
      switch self {
          case .sun: return "SUN"
          case .mon: return "MON"
          case .tue: return "TUE"
          case .wed: return "WED"
          case .thu: return "THU"
          case .fri: return "FRI"
          case .sat: return "SAT"

      }
    }
    
    var kor : String {
      switch self {
          case .sun: return "일"
          case .mon: return "월"
          case .tue: return "화"
          case .wed: return "수"
          case .thu: return "목"
          case .fri: return "금"
          case .sat: return "토"

      }
    }
    
    var total : Int{
        switch self {
            case .sun: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 1)
            case .mon: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 2)
            case .tue: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 3)
            case .wed: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 4)
            case .thu: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 5)
            case .fri: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 6)
            case .sat: return HabitVM.shared.getNumOfTodayHabit(todayWeek: 7)
   
        }
        
    }
}
