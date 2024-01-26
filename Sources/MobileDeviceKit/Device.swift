import CMobileDeviceKit
import Logging

// TODO: 添加设备配对状态改变事件

public class Device: Identifiable {
    private let logger: Logger
    var deviceRef: AMDeviceRef

    public internal(set) var userDeniedPairing: Bool = false
    /// The returned value is only valid when unpaired
    public internal(set) var isPasswordProtected: Bool = false
    public internal(set) var isPaired: Bool = false

    // public internal(set) var deviceInformation: DeviceInformation?
    // public internal(set) var diskUsage: DiskUsage?

    public var id: String {
        return copyDeviceIdentifier(deviceRef) as String
    }

    public var isValidConnect: Bool {
        return AMDeviceIsValid(deviceRef)
    }

    public var uniqueDeviceId: String {
        return copyDeviceIdentifier(deviceRef) as String
    }

    public var developerModeEnabled: Bool {
        var error: AMDError = 0
        return AMDeviceCopyDeveloperModeStatus(deviceRef, &error)
    }

    init(_ deviceRef: AMDeviceRef, logger: Logger? = nil) {
        self.logger = logger ?? .init(label: "org.martinlau.MobileDeviceKit.Device")
        self.deviceRef = deviceRef
        requestDevicePairingStatus()
    }

    deinit {
        dispose()
    }

    func requestDevicePairingStatus() {
        do {
            try validatePairing(deviceRef)
            isPasswordProtected = false
            userDeniedPairing = false
            isPaired = true
        } catch let err as MobileDeviceError {
            isPaired = false
            if err == .notConnected || err == .passwordProtected {
                isPasswordProtected = true
            } else if err == .userDeniedPairing {
                userDeniedPairing = true
            }
            print(err.reason)
            print(err.errorDescription ?? "Unknown error")
        } catch {}
    }

    // MARK: - Public -

    public func refreshDeviceInformation() throws -> DeviceInformation? {
        return try copyDeviceAllValue(deviceRef, basePaired: isPaired)
    }

    // public func refreshDiskUsageInfo() throws -> DiskUsage {
    //     if let value = try copyValueFromDevice(deviceRef, domain: kAMDDiskUsageFactoryDomain, key: nil) {
    //         if let infoDict = value as? [String: Any] {
    //             return try DiskUsage(infoDict, format: .plist)
    //         }
    //     }
    //     return nil
    // }

    public func copyDeviceLocationID() -> UInt32 {
        return AMDeviceCopyDeviceLocation(deviceRef)
    }

    /// 撷取连接 ID
    public func getConnectionId() -> UInt32 {
        return AMDeviceGetConnectionID(deviceRef)
    }

    public func getInterfaceSpeed() -> UInt32 {
        return AMDeviceGetInterfaceSpeed(deviceRef)
    }

    public func enterRecovery() throws {
        try MobileDeviceError.checkError { AMDeviceEnterRecovery(deviceRef) }
    }

    public func dispose() {
        try? releaseDevice(deviceRef)
    }
}
