import Foundation

struct StatisticsModel: Identifiable, Equatable {
    let year: Int
    let days: [Int]
    let week: [Int]
    let month: [Int]
    let total: Int
    let classification: String

    var id: String { "\(classification)-\(year)" }

    init(year: Int, days: [Int], week: [Int], month: [Int], total: Int, classification: String) {
        self.year = year
        self.days = days
        self.week = week
        self.month = month
        self.total = total
        self.classification = classification
    }

    func dayCount(for index: Int) -> Int {
        guard index >= 0 && index < days.count else { return 0 }
        return days[index]
    }

    func weekCount(for index: Int) -> Int {
        guard index >= 0 && index < week.count else { return 0 }
        return week[index]
    }

    func monthCount(for index: Int) -> Int {
        guard index >= 0 && index < month.count else { return 0 }
        return month[index]
    }
}
