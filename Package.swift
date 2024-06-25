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
            exclude: ["Info.plist", "Media.xcassets", "PrivacyInfo.xcprivacy"],
            resources: [
                .process("Media.xcassets"),
                .process("ar.lproj"),
                .process("en.lproj"),
                .process("PrivacyInfo.xcprivacy")
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
