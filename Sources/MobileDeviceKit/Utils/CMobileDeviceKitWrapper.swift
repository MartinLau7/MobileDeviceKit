import CMobileDeviceKit

// MARK: - Device

public enum DeviceConnectInterfaceType: Int32 {
    /// The device is connected through a physical connection like USB or FireWire.
    case wired = 1
    /// The device is connected wirelessly over Wi-Fi.
    case wireless = 2
    case companion = 3
    case unknown = 0
}

func copyDeviceIdentifier(_ deviceRef: AMDeviceRef) -> CFString {
    return AMDeviceCopyDeviceIdentifier(deviceRef).takeRetainedValue()
}

func copyPairedCompanion(_ deviceRef: AMDeviceRef) -> AMDeviceRef {
    return AMDeviceCopyPairedCompanion(deviceRef)
}

func releaseDevice(_ deviceRef: AMDeviceRef) throws {
    try MobileDeviceError.checkError { AMDeviceRelease(deviceRef) }
}

func retainDevice(_ deviceRef: AMDeviceRef) throws {
    try MobileDeviceError.checkError { AMDeviceRetain(deviceRef) }
}

func validatePairing(_ deviceRef: AMDeviceRef) throws {
    try connectDevice(deviceRef)
    defer { try? disconnect(deviceRef) }
    try MobileDeviceError.checkError { AMDeviceValidatePairing(deviceRef) }
}

func isDevicePaired(_ deviceRef: AMDeviceRef) -> Bool {
    return AMDeviceIsPaired(deviceRef) == 1
}

func pairDevice(_ deviceRef: AMDeviceRef) throws {
    return try MobileDeviceError.checkError { AMDevicePair(deviceRef) }
}

func pairDevice(_ deviceRef: AMDeviceRef, with options: CFDictionary) throws {
    return try MobileDeviceError.checkError { AMDevicePairWithOptions(deviceRef, options) }
}

func unpairDevice(_ deviceRef: AMDeviceRef) throws {
    return try MobileDeviceError.checkError { AMDeviceUnpair(deviceRef) }
}

func connectDevice(_ deviceRef: AMDeviceRef) throws {
    try MobileDeviceError.checkError { AMDeviceConnect(deviceRef) }
}

func disconnect(_ deviceRef: AMDeviceRef) throws {
    return try MobileDeviceError.checkError { AMDeviceDisconnect(deviceRef) }
}

func startDeviceSession(_ deviceRef: AMDeviceRef) throws {
    return try MobileDeviceError.checkError { AMDeviceStartSession(deviceRef) }
}

func stopDeviceSession(_ deviceRef: AMDeviceRef) throws {
    return try MobileDeviceError.checkError { AMDeviceStopSession(deviceRef) }
}

// AMDeviceGetInterfaceType
func getDeviceInterfaceType(_ device: AMDeviceRef) -> DeviceConnectInterfaceType {
    return DeviceConnectInterfaceType(rawValue: AMDeviceGetInterfaceType(device).rawValue) ?? .unknown
}

// AMDeviceGetName
func getDeviceName(_ device: AMDeviceRef) -> String? {
    guard let udid = AMDeviceGetName(device) else {
        return nil
    }
    return udid.takeRetainedValue() as String
}

func copyValueFromDevice(_ deviceRef: AMDeviceRef, domain: String?, key: String?, basePaired: Bool = true) throws -> Any? {
    try connectDevice(deviceRef)
    defer { try? disconnect(deviceRef) }

    defer { try? stopDeviceSession(deviceRef) }
    if basePaired {
        try startDeviceSession(deviceRef)
    }
    let value = AMDeviceCopyValue(deviceRef, domain?.toCFString(), key?.toCFString())
    return value?.takeRetainedValue()
}

// func copyDeviceAllValue(_ deviceRef: AMDeviceRef, basePaired: Bool = true) throws -> DeviceInformation? {
//     if let value = try copyValueFromDevice(deviceRef, domain: nil, key: nil, basePaired: basePaired) as? [String: Any] {
//         return try DeviceInformation(value, format: .plist)
//     }
//     return nil
// }

// MARK: - AFC(Apple File Connect)

public func getClientVersionString() -> String {
    return String(cString: AFCGetClientVersionString())
}
