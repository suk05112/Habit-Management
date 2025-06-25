// swift-tools-version: 5.9
import PackageDescription


#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    let packageSettings: PackageSettings = .make(
        productTypes: [
            SPM.TCA: .framework,
            SPM.FirebaseAnalytics : .framework,
            SPM.FirebaseAnalyticsSwift : .framework,
            SPM.FirebaseDatabase : .framework,
            SPM.FirebaseDatabaseSwift : .framework,
            SPM.protoc : .framework,
            SPM.Realm : .framework,
            SPM.RealmSwift : .framework,
            SPM.SwiftProtobuf : .framework,
            SPM.SwiftProtobufPluginLibrary : .framework,
        ]
    )
#endif

let package = Package(
    name: Environment.appName,
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "9.0.0"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.33.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.6.0"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.29.0")
    ]
)
