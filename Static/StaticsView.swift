//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/03.
//

import Foundation
import SwiftUI

struct StaticsView: View {

    @State var ratio: Double = Double(5/6)
    @StateObject var completedVM = compltedLIstVM.shared
    @StateObject var staticVM = StaticVM.shared

    var body: some View {
        VStack{
            HStack{
                Text("Statics")
                    .font(.system(size: 30))
                Spacer()
                
            }
            .padding()
            scrollView(ratio: 5/6)
            
            ZStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .frame(width: .none, height: 80)

                    HStack{
                        VStack(alignment: .leading){
                            Text("지난 주 보다 '물마시기'를 2번 더 완료했어요!")
                                .font(.system(size: 15, weight: .medium))
                            HStack{
                                Text("지난 주 대비")
                                    .font(.system(size: 12))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                                Text("20% up")
                                    .font(.system(size: 12))
                                    .bold()
                                    .foregroundColor(Color(hex: "#38AC3C"))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                            }
                            
                        }
                        Spacer()
                        HStack{}
                    }
                    .padding(20)
                }
            }
            Spacer()
            Graph(ratio: 1)
            Spacer()
            HStack{
                TotalView(.week, staticVM: staticVM)
                TotalView(.month, staticVM: staticVM)
                TotalView(.year, staticVM: staticVM)
                TotalView(.all, staticVM: staticVM)

            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        }
    }
}

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
            print("week", week)
            print("weekday =", todayComps.weekday)
            print(week[(7-todayComps.weekday!)..<week.endIndex])
            count = week[(7-todayComps.weekday!)..<week.endIndex].reduce(0, +)
        case .month:
            let month = staticVM.month
            print("mont = ", month)
            count = month[todayComps.month!-1]
        case .year:
            count = staticVM.yearTotal

        case .all:
            count = staticVM.total
            print("all")
        }
        
        staticStr = String(staticCase.rawValue)

    }
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 85, height: 57)
                .shadow(radius: 1)
            VStack{
                Text("\(count)")
                    .font(.system(size: 23, weight: .thin))
                Text("\(staticStr)")
                    .font(.system(size: 12, weight: .regular))
            }
            
        }
    }

}

