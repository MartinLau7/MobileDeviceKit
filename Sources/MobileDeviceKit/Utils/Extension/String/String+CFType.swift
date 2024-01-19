import Foundation

typealias UnmanagedCFString = Unmanaged<CFString>

extension UnmanagedCFString {
    func toString() -> String {
        return takeRetainedValue() as String
    }
}

extension String {
    init(_ reference: Unmanaged<CFString>) {
        self = reference.toString()
    }

    func toCFString() -> CFString {
        return self as CFString
    }
}
