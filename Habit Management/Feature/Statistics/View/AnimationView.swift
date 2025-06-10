//
//  ReportView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/02.
//

import Foundation
import SwiftUI

struct AnimationView: View{
    @StateObject var staticVM = StaticVM.shared
    let today_total = HabitVM.shared.getNumOfTodayHabit()
    let today_done = StaticVM.shared.getData(selected: 1).last!
    let yesterday_done = StaticVM.shared.getData(selected: 1)[5]
    
    @State var index: Int = 0
    @State var timer = Timer.publish(every: 2, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect()
    var colors: [Color] = [Color.red, Color.blue, Color.green, Color.orange, Color.purple]
    var str = ["1111111111", "2222222222", "33333333", "4444444"]
    var list: [String] = []
    
    init(){
//        list = getReportText()
        index = list.count
    }
    
    var body: some View {

         ZStack{
             RoundedRectangle(cornerRadius: 10, style: .continuous)
                 .fill(Color.white)
                 .shadow(radius: 5)
                 .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                 .scaledFrame(width: .none, height: 80)
                 

             ZStack{
                 ForEach(list.indices) { i in
                     if index == i {

                         VStack(alignment: .leading){
                             
                             Text("\(list[i])")
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
                        .transition(.cubeRotation)
                         
                     }
                 }
             }
             .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 15))
             .frame(width: .none, height: 40)
             .onReceive(timer) { _ in
                 withAnimation(.easeInOut(duration: 1.2)) {
                     index = (index + 1) % list.count
                     sleep(3)
                 }
             }
         }
         
    }
    
    

}
