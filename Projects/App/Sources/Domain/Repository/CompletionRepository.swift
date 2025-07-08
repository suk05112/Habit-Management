import Foundation

protocol CompletionRepository {
    func create(_ completion: CompletionModel) async throws
    func read(date: String) async throws -> CompletionModel?
    func update(_ completion: CompletionModel) async throws
    func delete(date: String) async throws
    func findAll() async throws -> [CompletionModel]
    func findAll(condition: String?) async throws -> [CompletionModel]
}
