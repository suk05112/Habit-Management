//
//  ReportData.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import SwiftUI
import ComposableArchitecture

class ReportData {
    let viewStore: ViewStore<StatisticsFeature.State, StatisticsFeature.Action>
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(ReportClient.self) var reportClient

    let todayDone: Int
    let yesterdayDone: Int

    var textList: [(String, String, String)] = []

    init(store: StoreOf<StatisticsFeature>) {
        self.viewStore = ViewStore(store, observe: { $0 })

        self.todayDone = viewStore.statisticsData.day.last ?? 0
        self.yesterdayDone = viewStore.statisticsData.day.count > 5 ? viewStore.statisticsData.day[5] : 0
        updateReportText()
    }

    func updateReportText() {
        var list: [(String, String, String)] = [
            getTodayReportText(), getYesterdayReportText(), getWeekReportText(), getMonthReportText(),
            getContinuityReportText(),
        ]

        list = list.filter { !($0.0.isEmpty && $0.2.isEmpty) }

        guard reportClient.hasHabitAndCompletionData() else {
            textList = [(L10n.tr("report.empty.line1"), L10n.tr("report.empty.line2"), "")]
            return
        }

        textList = list
    }

    func getReportTextEntries() -> [(String, String, String)] {
        textList
    }

    func getRandomReportText() -> (String, String, String) {
        guard !textList.isEmpty else {
            return (L10n.tr("report.no_data"), "", "")
        }

        let randomInt = Int.random(in: 0..<textList.count)
        return textList[randomInt]
    }

    func getTodayReportText() -> (String, String, String) {
        let todayDone = viewStore.statisticsData.day.last ?? 0
        let todayTotal = reportClient.todayHabitCount()

        let percentHead = ""
        var str: String = ""

        if todayTotal == todayDone + 1 {
            let completedIDs = reportClient.todayCompletedIDs()
            for item in reportClient.todayHabits()
                where !completedIDs.contains(item.id ?? "") {
                str = item.name
                break
            }
        }
        return str == "" ? ("", "", percentHead) : (L10n.tr("report.today_one_left", str), "", percentHead)
    }

    func getYesterdayReportText() -> (String, String, String) {
        let todayTotal = reportClient.todayHabitCount()
        guard todayTotal != 0 else { return ("", "", "") }
        let todayDone = viewStore.statisticsData.day.last ?? 0

        var text: String
        var percent: String
        let percentHead = L10n.tr("report.head.yesterday")

        guard viewStore.statisticsData.day.count > 5 else {
            return ("", "", "")
        }
        let yesterdayDone = viewStore.statisticsData.day[5]

        guard !viewStore.todoPerDay.isEmpty else {
            return ("", "", "")
        }

        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!

        let todayIndex = (todayWeek - 1 + 7) % 7
        let yesterdayIndex = (todayWeek - 2 + 7) % 7

        guard todayIndex < viewStore.todoPerDay.count,
              yesterdayIndex < viewStore.todoPerDay.count
        else {
            return ("", "", "")
        }

        let todayTodo = viewStore.todoPerDay[todayIndex]
        let yesterdayTodo = viewStore.todoPerDay[yesterdayIndex]

        text = getLocalizedCompareText(
            thisDone: todayDone, lastDone: yesterdayDone, periodKey: "report.period.yesterday")
        percent = getPercent(
            thisDone: todayDone, lastDone: yesterdayDone, thisTodo: todayTodo, lastTodo: yesterdayTodo)

        return (text, percentHead, percent)
    }

    func getWeekReportText() -> (String, String, String) {
        let percentHead = L10n.tr("report.head.last_week")

        guard let weekNO = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear,
              weekNO > 1
        else {
            return ("", "", "")
        }

        guard weekNO - 1 < viewStore.statisticsData.week.count,
              weekNO - 2 >= 0,
              weekNO - 1 < viewStore.todoPerWeek.count,
              weekNO - 2 < viewStore.todoPerWeek.count
        else {
            return ("", "", "")
        }

        let thisWeekDone = viewStore.statisticsData.week[weekNO - 1]
        let lastWeekDone = viewStore.statisticsData.week[weekNO - 2]
        let thisWeekTodo = viewStore.todoPerWeek[weekNO - 1]
        let lastWeekTodo = viewStore.todoPerWeek[weekNO - 2]

        let text = getLocalizedCompareText(
            thisDone: thisWeekDone, lastDone: lastWeekDone, periodKey: "report.period.last_week")
        let percent = getPercent(
            thisDone: thisWeekDone, lastDone: lastWeekDone, thisTodo: thisWeekTodo,
            lastTodo: lastWeekTodo)

        return (text, percentHead, percent)
    }

    func getMonthReportText() -> (String, String, String) {
        let percentHead = L10n.tr("report.head.last_month")

        guard let todayMonth = Calendar.current.dateComponents([.month], from: Date()).month,
              todayMonth > 1
        else {
            return ("", "", "")
        }

        let thisMonthIndex = (todayMonth - 1 + 7) % 7
        let lastMonthIndex = (todayMonth - 2 + 7) % 7

        guard thisMonthIndex < viewStore.statisticsData.month.count,
              lastMonthIndex < viewStore.statisticsData.month.count,
              thisMonthIndex < viewStore.todoPerMonth.count,
              lastMonthIndex < viewStore.todoPerMonth.count
        else {
            return ("", "", "")
        }

        let thisMonthDone = viewStore.statisticsData.month[thisMonthIndex]
        let lastMonthDone = viewStore.statisticsData.month[lastMonthIndex]
        let thisMonthTodo = viewStore.todoPerMonth[thisMonthIndex]
        let lastMonthTodo = viewStore.todoPerMonth[lastMonthIndex]

        let text = getLocalizedCompareText(
            thisDone: thisMonthDone, lastDone: lastMonthDone, periodKey: "report.period.last_month")
        let percent = getPercent(
            thisDone: thisMonthDone, lastDone: lastMonthDone, thisTodo: thisMonthTodo,
            lastTodo: lastMonthTodo)

        return (text, percentHead, percent)
    }

    func getContinuityReportText() -> (String, String, String) {
        var text: String = ""
        let percentHead = ""

        let allDoneContinuity = userDefaultsClient.integerForKey("allDoneContinuity")

        if allDoneContinuity != 0 {
            text = L10n.tr("report.continuity", allDoneContinuity)
        }

        return (text, percentHead, "")
    }

    func getLocalizedCompareText(thisDone: Int, lastDone: Int, periodKey: String) -> String {
        let period = L10n.tr(periodKey)
        if thisDone > lastDone {
            return L10n.tr("report.cmp.more", period, thisDone - lastDone)
        } else if thisDone == lastDone {
            return L10n.tr("report.cmp.same", period)
        } else {
            return L10n.tr("report.cmp.less", period, lastDone - thisDone)
        }
    }

    func getPercent(thisDone: Int, lastDone: Int, thisTodo: Int, lastTodo: Int) -> String {
        var percent = ""

        if thisDone == 0 && thisTodo == 0 && lastDone == 0 && lastTodo == 0 {
            percent = ""
        } else if lastDone == 0 || lastTodo == 0 {
            if thisTodo == 0 {
                percent = "\(thisDone * 100)"
            } else {
                percent = "\(Int(((Double(thisDone) / Double(thisTodo))) * Double(100)))"
            }
        } else if thisDone == 0 || thisTodo == 0 {
            percent = "-\(Int(((Double(lastDone) / Double(lastTodo))) * Double(100)))"
        } else {
            percent =
                "\(Int(((Double(thisDone) / Double(thisTodo)) - ((Double(lastDone) / Double(lastTodo)))) * Double(100)))"
        }

        if thisDone > lastDone {
            percent += L10n.tr("report.suffix.up")
        } else if thisDone == lastDone {
            percent = ""
        } else {
            percent += L10n.tr("report.suffix.down")
        }

        return percent
    }
}

extension ReportData {
    func getMainReportText() -> String {
        reportClient.mainHeaderReportText()
    }
}
