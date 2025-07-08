import Foundation
import RealmSwift

extension HabitModel {
    func toRealmEntity() -> Habit {
        let habit = Habit()
        habit.id = self.id
        habit.name = self.name
        habit.continuity = self.continuity
        habit.dataArray = self.weekIter
        return habit
    }
}

extension Habit {
    func toDomainModel() -> HabitModel {
        return HabitModel(
            id: self.id ?? UUID().uuidString,
            name: self.name,
            weekIter: self.dataArray,
            continuity: self.continuity
        )
    }
}
