//
//  ReportData.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import SwiftUI
import RealmSwift
import ComposableArchitecture

class ReportData {
    let store: StoreOf<StatisticsFeature>
    let viewStore: ViewStore<StatisticsFeature.State, StatisticsFeature.Action>

//    static let shared = ReportData()
    private static var _shared: ReportData?
    private(set) static var shared: ReportData = {
        guard let instance = _shared else {
            fatalError("ReportData.shared must be configured before use.")
        }
        return instance
   }()
    
    @StateObject var completedListViewModel = CompletedListViewModel.shared

    let today_total = HabitViewModel.shared.getNumberOfTodayHabits()
    let today_done: Int
    let yesterday_done: Int
//    let today_done = StaticVM.shared.day.last!

    var strList:[String] = []
    var percentList: [String] = []
    var percentHeadList: [String] = ["", "어제 대비", "지난 주 대비", "지난 달 대비", "", ""]
    var TextList : [(String, String, String)] = []
    var realm: Realm? = try? Realm()

    init(store: StoreOf<StatisticsFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        
        self.today_done = viewStore.statisticsData.day.last ?? 0
        self.yesterday_done = viewStore.statisticsData.day.count > 5 ? viewStore.statisticsData.day[5] : 0
        updateReportText()
    }

    static func configure(store: StoreOf<StatisticsFeature>) {
        _shared = ReportData(store: store)
    }

    func updateReportText() {
        var list: [(String, String, String)] = [getTodayReportText(), getYesterdayReportText(), getWeekReportText(), getMonthReportText(), getContinuityReportText()]
        
        list = list.filter { !($0.0.isEmpty && $0.2.isEmpty) }
        
        guard let realm = realm,
              let firstHabit = realm.objects(Habit.self).first,
              let lastCompleted = realm.objects(CompletedList.self).last else {
            TextList = [("아직 완료된 습관이 없습니다", "습관을 완료해 주세요.", "")]
            return
        }
        
        if firstHabit == nil || lastCompleted.completed.isEmpty {
            TextList = [("아직 완료된 습관이 없습니다", "습관을 완료해 주세요.", "")]
        } else {
            TextList = list
        }
    }
    
    func getReportTextEntries() -> [(String, String, String)] {
        return TextList
    }

    func getRandomReportText() -> (String, String, String) {
        guard !TextList.isEmpty else {
            return ("데이터가 없습니다", "", "")
        }
        
        let randomInt = Int.random(in: 0..<TextList.count)
        return TextList[randomInt]
    }
    
    func getTodayReportText() -> (String, String, String) {
        let today_done = viewStore.statisticsData.day.last ?? 0
        let today_total = HabitViewModel.shared.getNumberOfTodayHabits()

        let percentHead = ""
        var str: String = ""

        if today_total == today_done + 1 {
            let today_doneList = CompletedListViewModel.shared.todayDoneList
            for item in HabitViewModel.shared.getTodayHabits() {
                if !today_doneList.completed.contains(item.id!){
                    str = item.name
                    break
                }
            }
        }
        return str=="" ? ("", "", percentHead) : ("\(str)만 완료하면 오늘 예정된 모든 습관을 완료할 수 있어요!", "", percentHead)
    }
    
    func getYesterdayReportText() -> (String, String, String) {
        guard today_total != 0 else { return ("", "", "") }
        let today_done = viewStore.statisticsData.day.last ?? 0

        var text: String
        var percent: String
        let percentHead = "어제 대비"

        guard viewStore.statisticsData.day.count > 5 else {
            return ("", "", "")
        }
        let yesterday_done = viewStore.statisticsData.day[5]
        
        guard !viewStore.todoPerDay.isEmpty else {
            return ("", "", "")
        }
        
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        let todayIndex = (todayWeek-1+7)%7
        let yesterdayIndex = (todayWeek-2+7)%7
        
        guard todayIndex < viewStore.todoPerDay.count,
              yesterdayIndex < viewStore.todoPerDay.count else {
            return ("", "", "")
        }
        
        let todayTodo = viewStore.todoPerDay[todayIndex]
        let yesterdayTodo = viewStore.todoPerDay[yesterdayIndex]

        text = getText(thisDone: today_done, lastDone: yesterday_done, "어제")
        percent = getPercent(thisDone: today_done, lastDone: yesterday_done, thisTodo: todayTodo, lastTodo: yesterdayTodo)
        
        return (text, percentHead, percent)
    }
    
    func getWeekReportText() -> (String, String, String) {
        let percentHead = "지난 주 대비"
        
        guard let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear,
              weekNO > 1 else {
            return ("", "", "")
        }
        
        guard weekNO - 1 < viewStore.statisticsData.week.count,
              weekNO - 2 >= 0,
              weekNO - 1 < viewStore.todoPerWeek.count,
              weekNO - 2 < viewStore.todoPerWeek.count else {
            return ("", "", "")
        }
        
        let thisWeekDone = viewStore.statisticsData.week[weekNO - 1]
        let lastWeekDone = viewStore.statisticsData.week[weekNO - 2]
        let thisWeekTodo = viewStore.todoPerWeek[weekNO - 1]
        let lastWeekTodo = viewStore.todoPerWeek[weekNO - 2]
        
        let text = getText(thisDone: thisWeekDone, lastDone: lastWeekDone, "지난 주")
        let percent = getPercent(thisDone: thisWeekDone, lastDone: lastWeekDone, thisTodo: thisWeekTodo, lastTodo: lastWeekTodo)
        
        return (text, percentHead, percent)
    }
    
    func getMonthReportText() -> (String, String, String) {
        let percentHead = "지난 달 대비"
        
        guard let todayMonth = Calendar.current.dateComponents([.month], from: Date()).month,
              todayMonth > 1 else {
            return ("", "", "")
        }
        
        let thisMonthIndex = (todayMonth - 1 + 7) % 7
        let lastMonthIndex = (todayMonth - 2 + 7) % 7
        
        guard thisMonthIndex < viewStore.statisticsData.month.count,
              lastMonthIndex < viewStore.statisticsData.month.count,
              thisMonthIndex < viewStore.todoPerMonth.count,
              lastMonthIndex < viewStore.todoPerMonth.count else {
            return ("", "", "")
        }
        
        let thisMonthDone = viewStore.statisticsData.month[thisMonthIndex]
        let lastMonthDone = viewStore.statisticsData.month[lastMonthIndex]
        let thisMonthTodo = viewStore.todoPerMonth[thisMonthIndex]
        let lastMonthTodo = viewStore.todoPerMonth[lastMonthIndex]
        
        let text = getText(thisDone: thisMonthDone, lastDone: lastMonthDone, "지난 달")
        let percent = getPercent(thisDone: thisMonthDone, lastDone: lastMonthDone, thisTodo: thisMonthTodo, lastTodo: lastMonthTodo)
        
        return (text, percentHead, percent)
    }
    
    func getContinuityReportText() -> (String, String, String) {
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

extension ReportData {
    func getMainReportText() -> String {
        var list: [(String, String)] = []

        let habits = HabitViewModel.shared.result
        guard !habits.isEmpty else {
            return "아직 완료된 습관이 없습니다."
        }
        
        habits.forEach {
            if $0.continuity > 0 {
                list.append((String($0.continuity), $0.name))
            }
        }
        
        guard !list.isEmpty else {
            return "아직 완료된 습관이 없습니다."
        }
        
        let randomInt = Int.random(in: 0..<list.count)
        return "\(list[randomInt].0)일째 \(list[randomInt].1) 실천 중!"
    }
}
