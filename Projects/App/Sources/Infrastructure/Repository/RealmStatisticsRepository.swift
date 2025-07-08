import Foundation
import RealmSwift

final class RealmStatisticsRepository: StatisticsRepository {
    private let realmManager: RealmManager<Statistics>

    init(realmManager: RealmManager<Statistics>) {
        self.realmManager = realmManager
    }

    func create(_ statistics: StatisticsModel) async throws {
        let realmEntity = statistics.toRealmEntity()
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

    func read(classification: String, year: Int) async throws -> StatisticsModel? {
        let statistics = try await findAll(
            condition: "classification == '\(classification)' AND year == \(year)")
        return statistics.first
    }

    func update(_ statistics: StatisticsModel) async throws {
        let realmEntity = statistics.toRealmEntity()
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

    func delete(classification: String, year: Int) async throws {
        let statistics = Statistics()
        statistics.classification = classification
        statistics.year = year
        try await withCheckedThrowingContinuation { continuation in
            realmManager.deleteWithObject(
                statistics, condition: "classification == '\(classification)' AND year == \(year)"
            ) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func findAll() async throws -> [StatisticsModel] {
        return try await findAll(condition: nil)
    }

    func findAll(condition: String?) async throws -> [StatisticsModel] {
        try await withCheckedThrowingContinuation { continuation in
            realmManager.fetchWith(condition: condition) { results in
                let models = results.map { $0.toDomainModel() }
                continuation.resume(returning: Array(models))
            }
        }
    }
}
