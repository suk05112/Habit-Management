import Foundation
import RealmSwift

final class RealmCompletionRepository: CompletionRepository {
    private let realmManager: RealmManager<CompletedList>

    init(realmManager: RealmManager<CompletedList>) {
        self.realmManager = realmManager
    }

    func create(_ completion: CompletionModel) async throws {
        let realmEntity = completion.toRealmEntity()
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

    func read(date: String) async throws -> CompletionModel? {
        let completions = try await findAll(condition: "date == '\(date)'")
        return completions.first
    }

    func update(_ completion: CompletionModel) async throws {
        let realmEntity = completion.toRealmEntity()
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

    func delete(date: String) async throws {
        let completion = CompletedList()
        completion.date = date
        try await withCheckedThrowingContinuation { continuation in
            realmManager.deleteWithObject(completion, condition: "date == '\(date)'") { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func findAll() async throws -> [CompletionModel] {
        return try await findAll(condition: nil)
    }

    func findAll(condition: String?) async throws -> [CompletionModel] {
        try await withCheckedThrowingContinuation { continuation in
            realmManager.fetchWith(condition: condition) { results in
                let models = results.map { $0.toDomainModel() }
                continuation.resume(returning: Array(models))
            }
        }
    }
}
