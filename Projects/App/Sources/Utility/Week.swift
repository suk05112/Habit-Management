//
//  Week.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation

enum Week: Int {
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
    
    var kor: String {
        switch self {
        case .sun: return L10n.tr("weekday.sun")
        case .mon: return L10n.tr("weekday.mon")
        case .tue: return L10n.tr("weekday.tue")
        case .wed: return L10n.tr("weekday.wed")
        case .thu: return L10n.tr("weekday.thu")
        case .fri: return L10n.tr("weekday.fri")
        case .sat: return L10n.tr("weekday.sat")
        }
    }
    
    /// 해당 요일에 예정된 습관 수 (Realm 직조회, HabitViewModel 미사용)
    var total: Int {
        RealmCalendarQueries.habitsScheduledCount(on: rawValue)
    }
}
