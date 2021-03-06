//
//  TotalView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import Foundation
import SwiftUI

struct TotalView: View{
    
    var staticVM: StaticVM = StaticVM.shared
    var staticStr: String
    var count = 0
    
    let todayComps = Calendar.current.dateComponents([.year, .month, .weekday, .weekOfMonth], from: Date())
    
    init(_ staticCase: Total, staticVM: StaticVM){
        
        self.staticVM = staticVM
        switch staticCase{
        case .week:
            let week = staticVM.day
            count = week[(7-todayComps.weekday!)..<week.endIndex].reduce(0, +)
        case .month:
            let month = staticVM.month
            count = month[todayComps.month!-1]
        case .year:
            count = staticVM.yearTotal

        case .all:
            count = staticVM.total
        }
        
        staticStr = String(staticCase.rawValue)

    }
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .scaledFrame(width: 85, height: 57)
                .shadow(radius: 1)
            VStack{
                Text("\(count)")
                    .scaledText(size: 23, weight: .thin)
                Text("\(staticStr)")
                    .scaledText(size: 12, weight: .regular)
                    
            }
            
        }
    }

}
