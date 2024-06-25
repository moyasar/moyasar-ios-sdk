// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MoyasarSdk",
    defaultLocalization: "ar", // Set this to your default localization language code
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
    ],
  // Exclude unwanted root-level directories
    exclude: ["docs", "fastlane", "assets", "build", "Gemfile", "Gemfile.lock"]
)
