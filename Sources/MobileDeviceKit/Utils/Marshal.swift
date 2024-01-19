import Foundation

struct Marshal {
    static func toUnretained<T: AnyObject>(_ obj: T) -> UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(obj).toOpaque()
    }
    
    static func toRetained<T: AnyObject>(_ obj: T) -> UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(obj).toOpaque()
    }
    
    static func toUnretainedReference<T : AnyObject>(_ ptr: UnsafeMutableRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }
    
    static func toRetainedReference<T : AnyObject>(_ ptr: UnsafeMutableRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
    }
}
