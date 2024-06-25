// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MoyasarSdk",
    defaultLocalization: "ar", // Set to your default localization language code
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
            exclude: ["Info.plist", "Media", "PrivacyInfo"], // Adjust exclusions as needed
            resources: [
                .process("Media.xcassets"),
                .process("Localizable")
            ]
        ),
        .testTarget(
            name: "MoyasarSdkTests",
            dependencies: ["MoyasarSdk"],
            path: "Sdk/MoyasarSdkTests",
            exclude: ["Info.plist"]
        ),
    ],
    // Exclude unwanted root-level directories
    exclude: ["docs", "fastlane"]
)
