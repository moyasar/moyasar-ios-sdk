import Foundation

private class BundleFindingDummy {}

extension Bundle {
    static var moyasar: Bundle {
           #if SWIFT_PACKAGE
           // For Swift Package Manager
           return .module
           #else
           // For CocoaPods
           return Bundle(for: BundleFindingDummy.self)
           #endif
       }
}
