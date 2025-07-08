import Foundation

struct CompletionModel: Identifiable, Equatable {
    let date: String
    let completed: [String]

    var id: String { date }

    init(date: String, completed: [String]) {
        self.date = date
        self.completed = completed
    }

    func isCompleted(habitId: String) -> Bool {
        return completed.contains(habitId)
    }

    func addingCompletion(habitId: String) -> CompletionModel {
        var newCompleted = completed
        if !newCompleted.contains(habitId) {
            newCompleted.append(habitId)
        }
        return CompletionModel(date: date, completed: newCompleted)
    }

    func removingCompletion(habitId: String) -> CompletionModel {
        let newCompleted = completed.filter { $0 != habitId }
        return CompletionModel(date: date, completed: newCompleted)
    }
}
