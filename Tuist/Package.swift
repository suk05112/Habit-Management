// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Habit Management",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "9.0.0"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.33.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.6.0"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.29.0")
    ]
)
