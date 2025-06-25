import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "App",
    targets: [
        .makeModule(
            name: Environment.appName,
            product: .app,
            bundleId: Environment.organizationName,
            dependencies: [
                .spm(.TCA),
                .spm(.FirebaseAnalytics),
                .spm(.FirebaseAnalyticsSwift),
                .spm(.FirebaseDatabase),
                .spm(.FirebaseDatabaseSwift),
                .spm(.protoc),
                .spm(.Realm),
                .spm(.RealmSwift),
                .spm(.SwiftProtobuf),
                .spm(.SwiftProtobufPluginLibrary),
            ]
        )
    ]
)
