import Foundation

func synchronized(_ lock: Any, _ closure: () -> ()) {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    closure()
}

func synchronized<T>(_ lock: Any, _ closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try closure()
}

struct LockQueue {
    private let queue: DispatchQueue
    
    init() {
        queue = DispatchQueue(label: "com.martin.MobileDeviceKit.\(String(describing: type(of: self)))")
    }
    
    func lock(closure: () -> Void) {
        queue.sync {
            closure()
        }
    }
    
    func lock<T>(closure: () -> T) -> T{
        return queue.sync {
            return closure()
        }
    }
}
