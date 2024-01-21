import CMobileDeviceKit

public class Device: Identifiable {
    var deviceRef: AMDeviceRef

    public internal(set) var userDeniedPairing: Bool = false
    public internal(set) var isConnected: Bool = false
    public internal(set) var deviceInformation: DeviceInformation?
    // public internal(set) var diskUsage: DiskUsage?

    public var id: String {
        if let deviceInformation {
            return deviceInformation.uniqueDeviceId
        }
        return copyDeviceIdentifier(deviceRef) as String
    }

    public var isValidConnect: Bool {
        return AMDeviceIsValid(deviceRef)
    }

    public var isPaired: Bool {
        // if let _ = try? validatePairing(deviceRef) {
        //     return true
        // }
        // return false

        do {
            try validatePairing(deviceRef)
            return true
        } catch let error as MobileDeviceError {
            print(error)
            return false
        } catch {
            return false
        }
    }

    public var isPasswordProtected: Bool {
        if isPaired {
            do {
                try validatePairing(deviceRef)
            } catch let err as MobileDeviceError {
                if err == .notConnected || err == .passwordProtected {
                    return true
                }
            } catch {
                return false
            }
        }
        return false
    }

    public var uniqueDeviceId: String {
        return copyDeviceIdentifier(deviceRef) as String
    }

    public var developerModeEnabled: Bool {
        var error: AMDError = 0
        return AMDeviceCopyDeveloperModeStatus(deviceRef, &error)
    }

    init(_ deviceRef: AMDeviceRef) {
        self.deviceRef = deviceRef
    }

    deinit {
        // dispose()
    }
}
