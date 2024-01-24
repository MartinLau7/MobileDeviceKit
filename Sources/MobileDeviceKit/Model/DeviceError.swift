enum DeviceConnectionError: Error {
    case pairingError(reason: String)
    case passwordProtected
}
