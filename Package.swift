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
            exclude: ["Info.plist", "Media", "PrivacyInfo"], // Adjust exclusions as needed
            resources: [
                .process("Media.xcassets"), // Ensure this path exists
                .process("ar.lproj"), // Include Arabic localization
                .process("en.lproj"),  // Include English localization
                .process("PrivacyInfo") // Include PrivacyInfo
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
