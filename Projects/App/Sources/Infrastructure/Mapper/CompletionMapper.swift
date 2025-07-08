import Foundation
import RealmSwift

extension CompletionModel {
    func toRealmEntity() -> CompletedList {
        let completedList = CompletedList()
        completedList.date = self.date
        completedList.dataArray = self.completed
        return completedList
    }
}

extension CompletedList {
    func toDomainModel() -> CompletionModel {
        return CompletionModel(
            date: self.date,
            completed: self.dataArray
        )
    }
}
