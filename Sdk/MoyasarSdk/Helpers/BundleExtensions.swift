import Foundation

private class BundleFindingDummy {}

extension Bundle {
    static var moyasar: Bundle {
        Bundle(for: BundleFindingDummy.self)
    }
}
