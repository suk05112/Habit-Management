import Foundation
import RealmSwift

final class RealmHabitRepository: HabitRepository {
    private let realmManager: RealmManager<Habit>

    init(realmManager: RealmManager<Habit>) {
        self.realmManager = realmManager
    }

    func create(_ habit: HabitModel) async throws {
        let realmEntity = habit.toRealmEntity()
        try await withCheckedThrowingContinuation { continuation in
            realmManager.addOrUpdate(object: realmEntity) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func read(id: String) async throws -> HabitModel? {
        let habits = try await findAll(condition: "id == '\(id)'")
        return habits.first
    }

    func update(_ habit: HabitModel) async throws {
        let realmEntity = habit.toRealmEntity()
        try await withCheckedThrowingContinuation { continuation in
            realmManager.addOrUpdate(object: realmEntity) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func delete(id: String) async throws {
        let habit = Habit()
        habit.id = id
        try await withCheckedThrowingContinuation { continuation in
            realmManager.deleteWithObject(habit, condition: "id == '\(id)'") { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func findAll() async throws -> [HabitModel] {
        return try await findAll(condition: nil)
    }

    func findAll(condition: String?) async throws -> [HabitModel] {
        try await withCheckedThrowingContinuation { continuation in
            realmManager.fetchWith(condition: condition) { results in
                let models = results.map { $0.toDomainModel() }
                continuation.resume(returning: Array(models))
            }
        }
    }
}
