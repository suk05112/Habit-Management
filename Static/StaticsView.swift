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
    
    @State private var showingDetail = false

    @State var index: Int = 0
    var list: [String] = ["list"]
    

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Statics")
                        .scaledText(size: 30, weight: .semibold)
                    Spacer()
                    
                }
                .scaledPadding(top: 10, leading: 20, bottom: 5, trailing: 15)
 
                scrollView()
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                        .scaledFrame(width: .none, height: 80)

                        VStack(alignment: .leading){
                            
                            Text("\(list[0])")
                                .scaledText(size: 15, weight: .medium)

                            HStack{
                                Text("지난 주 대비")
                                    .scaledText(size: 12, weight: .none)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                                Text("20% up")
                                    .scaledText(size: 12, weight: .semibold)
                                    .foregroundColor(Color(hex: "#38AC3C"))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                            }
   
                        }
                    
                        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 15))
                        .scaledFrame(width: .none, height: 40)

                }
                .sheet(isPresented: $showingDetail){
                    DetailView()
                }
                .onTapGesture {
                    showingDetail = true
                }
                .scaledPadding(top: 10, leading: 0, bottom: 0, trailing: 0)

    //            ReportView()
                
                Spacer()
                Graph(ratio: 1)
                Spacer()
                HStack{
                    TotalView(.week, staticVM: staticVM)
                    TotalView(.month, staticVM: staticVM)
                    TotalView(.year, staticVM: staticVM)
                    TotalView(.all, staticVM: staticVM)

                }
                .scaledPadding(top: 0, leading: 0, bottom: 30, trailing: 0)
            }
//            if $showingDetail.wrappedValue {
//                DetailView(showingModal: $showingDetail)
//
//            }
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

