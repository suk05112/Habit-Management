//
//  ReportView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/02.
//

import Foundation
import SwiftUI

struct ReportView: View{
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
        list = getReportText()
        index = list.count
    }
    
    var body: some View {
        
         ZStack{
             RoundedRectangle(cornerRadius: 10, style: .continuous)
                 .fill(Color.white)
                 .shadow(radius: 5)
                 .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                 .frame(width: .none, height: 80)
                 

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
    
    
    func getReportText() -> [String]{
        var list:[String] = []
        
        if let todayText = getTodayText() {
            list.append(todayText)
        }

        list.append(getYesterDayText())
        list.append(getWeekText())
        list.append(getMonthText())
        if let continuity = getCotinuityText() {
            list.append(continuity)
        }

        print(list)
        return list
    }
    
    func getTodayText() -> String?{

        if today_total == today_done+1{
            return "이 습관만 완료하면 오늘 예정된 모든 습관을 완료할 수 있어요!"
        }
        return nil

    }
    func getYesterDayText() -> String{
        var text: String


        if today_done > yesterday_done{
            text = "어제보다 예정된 습관을 \(today_done-yesterday_done)개 더 완료했어요!"
        }
        else{
            text = "어제보다 예정된 습관을 \(yesterday_done - today_done)개를 덜 완료했어요!"
        }
        return text
    }
    
    func getWeekText() -> String{
        var text: String

        let thisWeek  = StaticVM.shared.week.last!
        let lastWeek = StaticVM.shared.week[3]
        
        if thisWeek > lastWeek{
            text = "지난주보다 예정된 습관을 \(thisWeek - lastWeek)개 더 완료했어요!"
        }
        else{
            text = "지난주보다 예정된 습관을 \(lastWeek - thisWeek)개 덜 완료했어요!"
        }
        
        return text

    }
    
    func getMonthText() -> String{
        var text: String

        let thisMonth  = StaticVM.shared.week.last!
        let lastMonth = StaticVM.shared.week[3]
        
        if thisMonth > lastMonth{
            text = "지난달보다 예정된 습관을 \(thisMonth - lastMonth)개 더 완료했어요!"
        }
        else{
            text = "지난달보다 예정된 습관을 \(lastMonth - thisMonth)개 덜 완료했어요!"
        }
        return text

    }
    
    func getCotinuityText() -> String?{
        var text: String?
        let allDoneContinuity = HabitVM.shared.getAllDoneContinuity()
        
        if allDoneContinuity != 0{
            text = "\(allDoneContinuity)일 연속 모든 습관을 완료했어요!"
        }
        

        return text
    }
}
