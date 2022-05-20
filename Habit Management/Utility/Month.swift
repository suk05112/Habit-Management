//
//  Month.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/15.
//

import Foundation

enum Month: Int{
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    
    var description : String {
      switch self {
          case .jan: return "JAN"
          case .feb: return "FEB"
          case .mar: return "MAR"
          case .apr: return "APR"
          case .may: return "MAY"
          case .jun: return "JUN"
          case .jul: return "JUL"
          case .aug: return "AUG"
          case .sep: return "SEP"
          case .oct: return "OCT"
          case .nov: return "NOV"
          case .dec: return "DEC"
      }
    }
}
