// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CTFeedbackSwift",
    defaultLocalization: "en",
    platforms: [
        // Some platform where run yours library
        .iOS(.v10), .tvOS(.v10), .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "CTFeedbackSwift", targets: ["CTFeedbackSwift"])
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "CTFeedbackSwift", path: "CTFeedbackSwift",
                resources: [.copy("Resources/PlatformNames.plist")])
    ]
)
