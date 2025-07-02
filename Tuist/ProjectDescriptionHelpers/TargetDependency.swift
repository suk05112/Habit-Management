import ProjectDescription

public enum Module {
    case core(Core)
    case spm(SPM)
}

public enum Core: String {
    case core = "core"
}

public enum SPM: String {
    case TCA = "ComposableArchitecture"
    case FirebaseAnalytics = "FirebaseAnalytics"
    case FirebaseAnalyticsSwift = "FirebaseAnalyticsSwift"
    case FirebaseDatabase = "FirebaseDatabase"
    case FirebaseDatabaseSwift = "FirebaseDatabaseSwift"
    case protoc = "protoc-gen-swift"
    case Realm = "Realm"
    case RealmSwift = "RealmSwift"
    case SwiftProtobuf = "SwiftProtobuf"
    case SwiftProtobufPluginLibrary = "SwiftProtobufPluginLibrary"
}

extension [Module] {
    public func asTargetDependencies() -> [TargetDependency] {
        map { $0.asTargetDependency() }
    }
}
extension Module {
    public func asTargetDependency() -> TargetDependency {
        switch self {
        case .core(let core):
            return .project(target: core.rawValue, path: .relativeToRoot("Projects/Core"))
        case .spm(let spm):
            return .external(name: spm.rawValue)
        }
    }
}

extension PackageSettings {
    public static func make(
        productTypes: [SPM : Product] = [:],
        productDestinations: [String : Destinations] = [:],
        baseSettings: Settings = .settings(),
        targetSettings: [String : Settings] = [:],
        projectOptions: [String : Project.Options] = [:]
    ) -> PackageSettings {
        let productTypes: [String : Product] = productTypes.map { [$0.key.rawValue: $0.value] }.first!
        return .init(
            productTypes: productTypes,
            productDestinations: productDestinations,
            baseSettings: baseSettings,
            targetSettings: targetSettings,
            projectOptions: projectOptions
        )
    }
}
