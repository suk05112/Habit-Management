//
//  Week.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import RealmSwift

enum Week: Int{
    case sun = 1, mon, tue, wed, thu, fri, sat
    
    var description : String {
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
    


}
