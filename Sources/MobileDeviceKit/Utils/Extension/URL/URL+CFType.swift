import Foundation

// MARK: - CFURL

typealias UnmanagedCFURL = Unmanaged<CFURL>

extension UnmanagedCFURL {
    
    func toURL() -> URL {
        return self.takeRetainedValue() as URL
    }
}

extension URL {
    
    init(_ reference: Unmanaged<CFURL>) {
        self = reference.toURL()
    }
    
    func toCFURL() -> CFURL {
        return self as CFURL
    }
}
