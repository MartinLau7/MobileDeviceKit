import CMobileDeviceKit

public extension Device {
    private var serviceName: String {
        kInstallationServiceName
    }

    typealias ApplicationServiceCallback = ([String: Any]?) -> Void
    typealias InstallationOperateCallback = (Int, String) -> Void

    private var defaultReturnAttributes: [String] {
        return [
            kApplicationDSIDKey,
            kApplicationSINFKey,
            "ApplicationType",
            "BuildMachineOSBuild",
            "CFBundleDevelopmentRegion",
            "CFBundleDisplayName",
            "CFBundleExecutable",
            "CFBundleIcons",
            "CFBundleIconFiles",
            "CFBundleIdentifier",
            "CFBundleLocalizations",
            "CFBundleName",
            "CFBundleShortVersionString",
            "CFBundleVersion",
            "Container",
            "MinimumOSVersion",
            "UIFileSharingEnabled",
            kSignerIdentityKey,
            "SignatureExpirationDate",
            kiTunesMetadataKey,
        ]
    }

    private func sendMessage(_ message: CFPropertyList, format: CFPropertyListFormat, option: CFDictionary? = nil, to serviceConnection: AMDServiceConnectionRef) throws {
        try MobileDeviceError.checkError { AMDServiceConnectionSendMessage(serviceConnection, message, format, option) }
    }

    private func sendCommandRequest(_ command: [String: Any], to serviceConnection: AMDServiceConnectionRef) throws {
        let commandMessage = command.toCFPropertyList()
        try sendMessage(commandMessage, format: .xmlFormat_v1_0, to: serviceConnection)
    }

    private func receiveMessage(from serviceConnection: AMDServiceConnectionRef) throws -> CFPropertyList? {
        var unmanagedProperties: Unmanaged<CFPropertyList>?
        var format: CFPropertyListFormat = .xmlFormat_v1_0
        try MobileDeviceError.checkError { AMDServiceConnectionReceiveMessage(serviceConnection, &unmanagedProperties, &format) }
        return unmanagedProperties?.takeRetainedValue()
    }

    private func receiveCommandResponse(from serviceConnection: AMDServiceConnectionRef) throws -> [String: Any] {
        if let responseDict = try receiveMessage(from: serviceConnection) {
            if CFGetTypeID(responseDict) == CFDictionaryGetTypeID() {
                return responseDict as! [String: Any]
            }
        }
        return [:]
    }

    func startService() throws -> AMDServiceConnectionRef? {
        try connectDevice(deviceRef)
        defer { try? disconnectDevice(deviceRef) }
        try startDeviceSession(deviceRef)
        defer { try? stopDeviceSession(deviceRef) }

        let connection = UnsafeMutablePointer<AMDServiceConnectionRef?>.allocate(capacity: 1)
        try MobileDeviceError.checkError { AMDeviceSecureStartService(deviceRef, serviceName.toCFString(), nil, connection) }
        return connection.pointee
    }
}
