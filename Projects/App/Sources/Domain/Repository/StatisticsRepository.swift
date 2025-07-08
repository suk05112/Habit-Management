import Foundation

protocol StatisticsRepository {
    func create(_ statistics: StatisticsModel) async throws
    func read(classification: String, year: Int) async throws -> StatisticsModel?
    func update(_ statistics: StatisticsModel) async throws
    func delete(classification: String, year: Int) async throws
    func findAll() async throws -> [StatisticsModel]
    func findAll(condition: String?) async throws -> [StatisticsModel]
}
