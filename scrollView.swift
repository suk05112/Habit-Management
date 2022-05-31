//
//  scrollView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import Foundation
import SwiftUI

struct scrollView: View{
    
    let scroll_data = ScrollData.shared
    var frame_size: CGFloat = CGFloat(24)

    var ratio:Double
    @StateObject var completedVM = compltedLIstVM.shared
    @StateObject var scrollVM = ScrollVM.shared
    @Namespace var endPoint
    
    
    init(ratio: Double){
        self.ratio = ratio
        frame_size = CGFloat(24*ratio)
    }
    
    var body: some View {

        ZStack{

            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(hex: "#639F70"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 250*ratio)
            
            VStack{
                HStack(alignment: .bottom){
                    VStack(alignment: .center ,spacing:12){
                        ForEach(1...7, id: \.self){ i in
                            WeekView(week: i)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                    
                    ScrollViewReader { proxy in
                        
                        ScrollView(.horizontal) {
                            
                            VStack(alignment: .center, spacing: 3){
                                HStack(alignment: .center, spacing: 3) {
                                    ForEach(scrollVM.MonthArray, id: \.self) { item in
                                        Text(item)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .frame(width: frame_size, height: frame_size)
                                    }
                                }
                                
                                HStack(alignment: .center, spacing: 3) {
                                    
                                    ForEach(scrollVM.DayArray, id:\.self){i in
                                        VStack(alignment: .center, spacing: 3) {
                                            ForEach(i, id:\.self){j in
                                                Text("\(j)")
                                                    .frame(width: frame_size, height: frame_size)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                            .fill(j == "" ? Color(hex: "#639F70"): getColor(date: j))
                                                            .frame(width: frame_size, height: frame_size)
                                                    )
                                            }
                                        }
                                    }
                                    HStack{}.id(endPoint)
                                    
                                }
                                
                            }
                        }
                        .onAppear(){
                            proxy.scrollTo(endPoint)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                
                HStack{
                    HStack{}
                    Spacer()
                    LessMore()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))


            }

        }
    }
    
    func getColor(date: String) -> Color{
        
        let count = completedVM.getCount(d: date)
        let total = HabitVM.shared.getNumOfTodayHabit()
        //        print("cout =", count)
        
        if count == 0 {
            return Color(hex: "#EFF0EF")
        }
        else if count == 1 || (count/total)*100 < 33{
            return Color(hex: "#CFEECB")
        }
        else if (count/total)*100 > 33 && (count/total)*100 < 66{
            return Color(hex: "#7BE084")
        }
        else{
            return Color(hex: "#118E15")
        }
        
    }
    
}


struct WeekView: View{
    
    let weekStr: String
    init(week: Int){
        weekStr = Week(rawValue: week)!.description
    }
    var body: some View {
        Text("\(weekStr)")
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(Color.white)
            .frame(height: 16)
            .padding((EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)))
    }
}
