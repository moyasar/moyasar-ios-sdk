// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MoyasarSdk",
    platforms: [
        .iOS(.v13), // Update to the minimum version of iOS you support
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
            exclude: ["Info.plist", "Media", "PrivacyInfo"],
            resources: [
                .process("Media.xcassets"),
                .process("Localizable") // Process resources from the Localizable folder
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
