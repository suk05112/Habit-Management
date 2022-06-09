//
//  DetailView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import SwiftUI

struct DetailView: View{
    
//    @Binding var showingModal: Bool

    @State var name: String = ""
    var list: ([String],[String]) = ([],[])
    let today_total = HabitVM.shared.getNumOfTodayHabit()
    let today_done = StaticVM.shared.getData(selected: 1).last!
    let yesterday_done = StaticVM.shared.getData(selected: 1)[5]
    
    init(){
        list = getReportText()
    }

    var body: some View {

        VStack{
            HStack{
                Text("Report")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                
            }
            .padding()
            
            ForEach(0..<list.0.count) { i in
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                        .scaledFrame(width: .none, height: 80)
                    
                    VStack(alignment: .leading){
                        
                        Text("\(list.0[i])")
                            .scaledText(size: 15, weight: .medium)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                        HStack{
                            Text("지난 주 대비")
                                .scaledText(size: 12, weight: .none)
                                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                            Text("\(list.1[i])")
                                .scaledText(size: 12, weight: .semibold)
                                .foregroundColor(Color(hex: "#38AC3C"))
                                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                        }

                    }
                    .scaledFrame(width: 300, height: .none)

                }
                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("바깥쪽 터치됨")
    //            self.showingModal = false

            }
            Spacer()
            HStack{}
        }
  

    }
        
}
extension DetailView{
    func getReportText() -> ([String],[String]){
        var strList:[String] = []
        var percentList: [String] = []
        
        if let todayText = getTodayText().0 {
            strList.append(todayText)
            percentList.append("")
        }

        let yesterday = getYesterDayText()
        let week = getWeekText()
        let month = getMonthText()
        
        strList.append(yesterday.0)
        percentList.append(yesterday.1)

        strList.append(week.0)
        percentList.append(week.1)

        strList.append(month.0)
        percentList.append(month.1)
        
        if let continuity = getCotinuityText().0 {
            strList.append(continuity)
            percentList.append("")
        }

        print(strList)
        return (strList, percentList)
    }
    
    func getTodayText() -> (String?, String?){

        var str: String? = nil
        if today_total == today_done+1{
            let today_doneList = compltedLIstVM.shared.todayDoneList
            HabitVM.shared.getTodayHabit().forEach{
                if !today_doneList.completed.contains($0.name){
                    str = $0.name
                    return
                }
            }
            return (String("\"\(str!)\"만 완료하면 오늘 예정된 모든 습관을 완료할 수 있어요!"), nil)
        }
        return (nil, "")

    }
    func getYesterDayText() -> (String, String){
        var text: String
        var percent: String

        if today_done > yesterday_done{
            text = "어제보다 예정된 습관을 \(today_done-yesterday_done)개 더 완료했어요!"
            percent = "\(Int((Double(today_done)/Double(yesterday_done))*Double(100)))% up"
        }
        else if today_done == yesterday_done{
            text = "어제만큼 예정된 습관을 완료했어요!"
            percent = "0% up"
        }
        else{
            text = "어제보다 예정된 습관을 \(yesterday_done - today_done)개를 덜 완료했어요!"
            percent = "\(-Int((Double(today_done)/Double(yesterday_done))*Double(100)))% down"

        }
        return (text, percent)
    }
    
    func getWeekText() -> (String, String){
        var text: String
        var percent: String

        let thisWeek  = StaticVM.shared.week.last!
        let lastWeek = StaticVM.shared.week[3]
        
        if thisWeek > lastWeek{
            text = "지난주보다 예정된 습관을 \(thisWeek - lastWeek)개 더 완료했어요!"
            percent = "\(Int((Double(thisWeek)/Double(lastWeek))*Double(100)))% up"
        }
        else if thisWeek == lastWeek{
            text = "지난주만큼 예정된 습관을 완료했어요!"
            percent = "0% up"

        }
        else{
            text = "지난주보다 예정된 습관을 \(lastWeek - thisWeek)개 덜 완료했어요!"
            percent = "\(-Int((Double(thisWeek)/Double(lastWeek))*Double(100)))% down"

        }
        
        return (text, percent)

    }
    
    func getMonthText() -> (String, String){
        var text: String
        var percent: String

        let thisMonth  = StaticVM.shared.week.last!
        let lastMonth = StaticVM.shared.week[3]
        
        if thisMonth > lastMonth{
            text = "지난달보다 예정된 습관을 \(thisMonth - lastMonth)개 더 완료했어요!"
            percent = "\(-Int((Double(thisMonth)/Double(lastMonth))*Double(100)))% down"

        }
        else if thisMonth == lastMonth{
            text = "지난달만큼 예정된 습관을 완료했어요!"
            percent = "0% up"
        }
        else{
            text = "지난달보다 예정된 습관을 \(lastMonth - thisMonth)개 덜 완료했어요!"
            percent = "\(-Int((Double(thisMonth)/Double(lastMonth))*Double(100)))% down"

        }
        return (text, percent)

    }
    
    func getCotinuityText() -> (String?, String?){
        var text: String?
        let allDoneContinuity = UserDefaults.standard.integer(forKey: "allDoneContinuity")

        
        if allDoneContinuity != 0{
            text = "\(allDoneContinuity)일 연속 모든 습관을 완료했어요!"
        }
        
        return (text, "")
    }
}
