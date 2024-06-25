// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MoyasarSdk",
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
            path: "MoyasarSdk",
            exclude: ["Info.plist", "Media", "PrivacyInfo"],
            resources: [
                .process("Media.xcassets"),
                .process("Localizable") // Process resources from the Localizable folder
            ]
        ),
        .testTarget(
            name: "MoyasarSdkTests",
            dependencies: ["MoyasarSdk"],
            path: "MoyasarSdkTests",
            exclude: ["Info.plist"]
        ),
    ]
)
