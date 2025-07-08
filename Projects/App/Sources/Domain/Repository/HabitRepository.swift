import Foundation

protocol HabitRepository {
    func create(_ habit: HabitModel) async throws
    func read(id: String) async throws -> HabitModel?
    func update(_ habit: HabitModel) async throws
    func delete(id: String) async throws
    func findAll() async throws -> [HabitModel]
    func findAll(condition: String?) async throws -> [HabitModel]
}
