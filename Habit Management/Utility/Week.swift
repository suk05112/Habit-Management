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
}
