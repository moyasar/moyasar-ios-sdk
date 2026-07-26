// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MoyasarSdk",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "MoyasarSdk",
            targets: ["MoyasarSdk"]
        ),
    ],
    targets: [
        .target(
            name: "MoyasarSdk",
            path: "Sdk/MoyasarSdk",
            exclude: ["Info.plist"],
            resources: [
                .process("Media.xcassets"),
                .process("ar.lproj"),
                .process("en.lproj"),
                .process("PrivacyInfo.xcprivacy"),
                // Flattened into the bundle root so lookups match the Xcode/CocoaPods layout.
                .process("Fonts")
            ]
        ),
        .testTarget(
            name: "MoyasarSdkTests",
            dependencies: ["MoyasarSdk"],
            path: "Sdk/MoyasarSdkTests",
            exclude: ["Info.plist"]
        ),
    ]
)
