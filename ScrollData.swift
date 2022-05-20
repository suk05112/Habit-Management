//
//  ScrollData.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/24.
//

import Foundation
import SwiftUI

class ScrollData {
    
    static let shared = ScrollData()
    
    var scrollData: [[String]] = [[]]
    var MonthArray: [String] = []
    var DayArray = [[String]](repeating: Array(repeating: "",count: 7 ), count: 53)

    init(){

    }
    

}
