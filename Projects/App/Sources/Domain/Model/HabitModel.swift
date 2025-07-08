import Foundation

struct HabitModel: Identifiable, Equatable {
    let id: String
    let name: String
    let weekIter: [Int]
    let continuity: Int

    init(id: String = UUID().uuidString, name: String, weekIter: [Int], continuity: Int = 0) {
        self.id = id
        self.name = name
        self.weekIter = weekIter
        self.continuity = continuity
    }

    func isWeekValidate() -> Bool {
        return !weekIter.isEmpty
    }

    func weekString() -> String {
        return
            weekIter
            .map { DateFormatters.standard.shortWeekdaySymbols[($0 - 1) % 7] }
            .joined(separator: ", ")
    }
}
