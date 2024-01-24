import CMobileDeviceKit
import SwiftUI

public struct MobileDeviceError: Error {
    var originalError: AMDError

    public var code: Int32 {
        return originalError
    }

    public var reason: String {
        if 600 ... 699 ~= code {
            return reasonFromCustomCode(code)
        } else {
            if let errorText = AMDCopyErrorText(code) {
                return errorText.takeRetainedValue() as String
            }
            return "unknown error"
        }
    }

    init(originalError: AMDError) {
        self.originalError = originalError
    }

    init(_ errCode: Int32) {
        originalError = AMDError(errCode)
    }

    static func checkError(_ amdfunc: () -> AMDError) throws {
        let err = amdfunc()
        guard err == 0 else {
            throw MobileDeviceError(originalError: err)
        }
    }

    public static func == (lhs: MobileDeviceError, rhs: MobileDeviceError) -> Bool {
        return lhs.originalError == rhs.originalError
    }

    private func reasonFromCustomCode(_ code: Int32) -> String {
        switch code {
        case 600:
            return "Service not found or cannot be accessed."
        case 601:
            return "Service cannot be connected."
        case 602:
            return "Copy value with the domain failed."
        default:
            return "unknown error"
        }
    }
}

public extension MobileDeviceError {
    // MARK: Custom Error

    static var serviceNotFoundOrNotOpen: MobileDeviceError {
        return MobileDeviceError(600)
    }

    static var serviceCanNotConnected: MobileDeviceError {
        return MobileDeviceError(601)
    }

    static var copyValueOfDomainFailed: MobileDeviceError {
        return MobileDeviceError(602)
    }

    // MARK: AMDError

    static var notConnected: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDNotConnectedError))
    }

    static var invalidHostID: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDInvalidHostIDError))
    }

    static var passwordProtected: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDPasswordProtectedError))
    }

    static var userDeniedPairing: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDUserDeniedPairingError))
    }

    /// The user has not yet responded to the pairing request.
    static var pairingDialogResponsePending: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDPairingDialogResponsePendingError))
    }

    static var missingPairRecord: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDMissingPairRecordError))
    }

    static var invalidPairRecord: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDInvalidPairRecordError))
    }

    static var escrowLocked: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDEscrowLockedError))
    }

    static var pairingProhibited: MobileDeviceError {
        return MobileDeviceError(AMDError(kAMDPasswordProtectedError))
    }
}

extension MobileDeviceError: LocalizedError {
    public var errorDescription: String? {
        return reason
    }
}
