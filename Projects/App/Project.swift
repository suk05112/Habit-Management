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
                //                .spm(.protoc),
                .spm(.Realm),
                .spm(.RealmSwift),
                .spm(.SwiftProtobuf),
                .spm(.SwiftProtobufPluginLibrary),
            ]
        ),
        .makeModule(
            name: "\(Environment.appName)Tests",
            product: .unitTests,
            bundleId: "\(Environment.organizationName)Tests",
            infoPlist: nil,
            sources: ["Tests/Sources/**"],
            resources: nil
        ),
        .makeModule(
            name: "\(Environment.appName)UITests",
            product: .uiTests,
            bundleId: "\(Environment.organizationName)UITests",
            infoPlist: nil,
            sources: ["UITests/Sources/**"],
            resources: nil
        ),
    ]
)
