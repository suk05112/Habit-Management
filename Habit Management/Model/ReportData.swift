//
//  ReportData.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import Foundation
import SwiftUI
import RealmSwift

class ReportData{
    
    static let shared = ReportData()
    @StateObject var completedVM = compltedLIstVM.shared

    let today_total = HabitVM.shared.getNumOfTodayHabit()
    let today_done = StaticVM.shared.day.last!

    var strList:[String] = []
    var percentList: [String] = []
    var percentHeadList: [String] = ["", "어제 대비", "지난 주 대비", "지난 달 대비", "", ""]
    var TextList : [(String, String, String)] = []
    var realm: Realm? = try? Realm()

    init(){
        setReportText()
    }
    
    func setReportText(){
        var list: [(String, String, String)] = [getTodayText(), getYesterDayText(), getWeekText(), getMonthText(), getCotinuityText()]
        
        for item in list{
            if item.0 == "" && item.2 == ""{
                list.removeAll(where: { $0 == item })
            }

        }
        if realm!.objects(Habit.self).first == nil || realm!.objects(CompletedList.self).last!.completed.isEmpty{
            TextList = [("아직 완료된 습관이 없습니다", "습관을 완료해 주세요.", "")]
        }else{
            TextList = list
        }
    }
    
    func getReportText() -> [(String, String, String)]{
        return TextList
    }
    
    func getRandomText() -> (String, String, String){
        let randomInt = Int.random(in: 0..<TextList.count)

        return (TextList[randomInt].0, TextList[randomInt].1, TextList[randomInt].2)
    }
    
    func getTodayText() -> (String, String, String){
        let today_done = StaticVM.shared.day.last!
        let today_total = HabitVM.shared.getNumOfTodayHabit()

        let percentHead = ""
        var str: String = ""
               
        if today_total == today_done+1{
            let today_doneList = compltedLIstVM.shared.todayDoneList
            for item in HabitVM.shared.getTodayHabit(){
                if !today_doneList.completed.contains(item.id!){
                    str = item.name
                    break
                }
            }
        }
        return str=="" ? ("", "", percentHead) : ("\(str)만 완료하면 오늘 예정된 모든 습관을 완료할 수 있어요!", "", percentHead)

    }
    func getYesterDayText() -> (String, String, String){
        let today_done = StaticVM.shared.day.last!

        var text: String
        var percent: String
        let percentHead = "어제 대비"

        let yesterday_done = StaticVM.shared.day[5]
        
        let todoCount = StaticVM.shared.getnumOfToDoPerDay()
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        let todayTodo = todoCount[(todayWeek-1+7)%7]
        let yesterdayTodo = todoCount[(todayWeek-2+7)%7]

        text = getText(thisDone: today_done, lastDone: yesterday_done, "어제")

        percent = getPercent(thisDone: today_done, lastDone: yesterday_done, thisTodo: todayTodo, lastTodo: yesterdayTodo)
        
        return (text, percentHead, percent)
    }
    
    func getWeekText() -> (String, String, String){
        var text: String
        var percent: String
        let percentHead = "지난 주 대비"

        let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!

        let thisWeekDone  = StaticVM.shared.week[(weekNO-1+7)%7]
        let lastWeekDone = StaticVM.shared.week[(weekNO-2+7)%7]
        
        let todoCount = StaticVM.shared.getnumOfToDoPerWeek()
        let thisWeekTodo  = todoCount[(weekNO-1+7)%7]
        let lastWeekTodo = todoCount[(weekNO-2+7)%7]
        
        text = getText(thisDone: thisWeekDone, lastDone: lastWeekDone, "지난 주")

        percent = getPercent(thisDone: thisWeekDone, lastDone: lastWeekDone, thisTodo: thisWeekTodo, lastTodo: lastWeekTodo)
        
        return (text, percentHead, percent)

    }
    
    func getMonthText() -> (String, String, String){
        var text: String
        var percent: String
        let percentHead = "지난 달 대비"

        let todayMonth = Calendar.current.dateComponents([.month], from: Date()).month!

        let thisMonthDone  = StaticVM.shared.month[(todayMonth-1+7)%7]
        let lastMonthDone = StaticVM.shared.month[(todayMonth-2+7)%7]
        
        let todoCount = StaticVM.shared.getnumOfToDoPerMonth()
        let thisMonthTodo  = todoCount[(todayMonth-1+7)%7]
        let lastMonthTodo = todoCount[(todayMonth-2+7)%7]
        
        text = getText(thisDone: thisMonthDone, lastDone: lastMonthDone, "지난 달")
        percent = getPercent(thisDone: thisMonthDone, lastDone: lastMonthDone, thisTodo: thisMonthTodo, lastTodo: lastMonthTodo)
        
        return (text, percentHead, percent)

    }
    
    func getCotinuityText() -> (String, String, String){
        var text: String = ""
        let percentHead = ""

        let allDoneContinuity = UserDefaults.standard.integer(forKey: "allDoneContinuity")
        
        if allDoneContinuity != 0{
            text = "\(allDoneContinuity)일 연속 모든 습관을 완료했어요!"
        }
        
        return (text, percentHead, "")
    }
    
    func getText(thisDone: Int, lastDone: Int, _ which: String) -> String{
        
        if thisDone > lastDone{
            return which + "보다 예정된 습관을 \(thisDone - lastDone)개 더 완료했어요!"
        }
        else if thisDone == lastDone{
            return which + "만큼 예정된 습관을 완료했어요!"
        }
        else{
            return which + "보다 예정된 습관을 \(lastDone - thisDone)개 덜 완료했어요!"
        }
    }

    func getPercent(thisDone: Int, lastDone: Int, thisTodo: Int, lastTodo: Int) -> String{
        var percent = ""
        
        if thisDone == 0 && thisTodo == 0 && lastDone == 0 && lastTodo == 0{
            percent = ""
        }
        else if lastDone == 0 || lastTodo == 0{
            if thisTodo == 0{
                percent = "\(thisDone*100)"
            }
            else{
                percent = "\(Int(((Double(thisDone)/Double(thisTodo)))*Double(100)))"
            }
        }
        else if thisDone == 0 || thisTodo == 0{
            percent = "-\(Int(((Double(lastDone)/Double(lastTodo)))*Double(100)))"
        }
        
        else{
            percent = "\(Int(((Double(thisDone)/Double(thisTodo)) - ((Double(lastDone)/Double(lastTodo))))*Double(100)))"
        }
        
        if thisDone > lastDone{
            percent += "% up"
        }
        else if thisDone == lastDone{
            percent = ""
        }
        else{
            percent += "% down"
        }
        
        return percent
        
    }

}

extension ReportData{
    
    func getMainReport() -> String{
        var list : [(String, String)] = []
        
        HabitVM.shared.result.forEach{
            if $0.continuity > 0{
                list.append((String($0.continuity), $0.name))
            }
        }
        
        if list.first == nil {
            return ("아직 완료된 습관이 없습니다.")
        }
        
        let randomInt = Int.random(in: 0..<list.count)

        return "\(list[randomInt].0)일째 \(list[randomInt].1) 실천 중!"
    }
}
