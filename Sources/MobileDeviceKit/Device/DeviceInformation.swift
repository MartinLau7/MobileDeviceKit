
import Foundation

// MARK: - BasebandKeyHashInformation

public struct BasebandKeyHashInformation: Codable {
    public let aKeyStatus: Int
    public let sKeyStatus: Int
    public let sKeyHash: Data?

    enum CodingKeys: String, CodingKey {
        case aKeyStatus = "AKeyStatus"
        case sKeyStatus = "SKeyStatus"
        case sKeyHash = "SKeyHash"
    }
}

// MARK: - CarrierBundleInfo

/// Carrier 基带版本
public struct CarrierBundleInfo: Codable {
    public let cfBundleIdentifier: String
    public let cfBundleVersion: String
    public let gid1: String?
    public let gid2: String?
    public let integratedCircuitCardIdentity: String
    public let internationalMobileSubscriberIdentity: String
    public let mcc: String
    public let mnc: String
    public let mobileEquipmentIdentifier: String?
    public let simgid1: Data?
    public let simgid2: Data?
    public let slot: String
    public let kCtPostponementInfoAvailable: String

    enum CodingKeys: String, CodingKey {
        case cfBundleIdentifier = "CFBundleIdentifier"
        case cfBundleVersion = "CFBundleVersion"
        case gid1 = "GID1"
        case gid2 = "GID2"
        case integratedCircuitCardIdentity = "IntegratedCircuitCardIdentity"
        case internationalMobileSubscriberIdentity = "InternationalMobileSubscriberIdentity"
        case mcc = "MCC"
        case mnc = "MNC"
        case mobileEquipmentIdentifier = "MobileEquipmentIdentifier"
        case simgid1 = "SIMGID1"
        case simgid2 = "SIMGID2"
        case slot = "Slot"
        case kCtPostponementInfoAvailable = "kCTPostponementInfoAvailable"
    }
}

// MARK: - NonVolatileRam

public struct NonVolatileRam: Codable {
    public let autoBoot: Data?
    public let backlightLevel: Data?
    public let backlightNits: Data?
    public let bootArgs: String?
    public let bootdelay: Data?
    public let comAppleSystemTz0Size: Data?
    public let fmAccountMasked: Data?
    public let fmActivationLocked: Data?
    public let fmSpkeys: Data?
    public let fmSpstatus: Data?
    public let oblitBegins: Data?
    public let obliteration: Data?
    public let otaControllerVersion: Data?
    public let usbcfwflasherResult: Data?

    enum CodingKeys: String, CodingKey {
        case autoBoot = "auto-boot"
        case backlightLevel = "backlight-level"
        case backlightNits = "backlight-nits"
        case bootArgs = "boot-args"
        case bootdelay
        case comAppleSystemTz0Size = "com.apple.System.tz0-size"
        case fmAccountMasked = "fm-account-masked"
        case fmActivationLocked = "fm-activation-locked"
        case fmSpkeys = "fm-spkeys"
        case fmSpstatus = "fm-spstatus"
        case oblitBegins = "oblit-begins"
        case obliteration
        case otaControllerVersion = "ota-controllerVersion"
        case usbcfwflasherResult
    }
}

// MARK: - DeviceInfo

public struct DeviceInformation: Codable {
    public let activationState: String?
    public let activationStateAcknowledged: Bool?
    public let basebandActivationTicketVersion: String?
    public let basebandCertId: Int?
    public let basebandChipId: Int?
    public let basebandKeyHashInformation: BasebandKeyHashInformation?
    public let basebandMasterKeyHash: String?
    public let basebandRegionSku: Data?
    public let basebandSerialNumber: Data?
    public let basebandStatus: String?
    public let basebandVersion: String?
    public let bluetoothAddress: String?
    public let boardId: Int
    public let brickState: Bool?
    public let buildVersion: String
    public let cpuArchitecture: String
    public let carrierBundleInfoArray: [CarrierBundleInfo]?
    public let certId: Int?
    public let chipId: Int
    public let chipSerialNo: Data?
    public let deviceClass: String
    public let deviceColor: String
    public let deviceName: String
    public let dieId: Int
    public let ethernetAddress: String?
    public let firmwareVersion: String?
    public let fusingStatus: Int?
    public let gid1: String?
    public let gid2: String?
    public let hardwareModel: String
    public let hardwarePlatform: String?
    public let hasSiDp: Bool
    public let hostAttached: Bool?
    public let integratedCircuitCardIdentity: String?
    public let integratedCircuitCardIdentity2: String?
    public let internationalMobileEquipmentIdentity: String?
    public let internationalMobileEquipmentIdentity2: String?
    public let internationalMobileSubscriberIdentity: String?
    public let internationalMobileSubscriberIdentity2: String?
    public let internationalMobileSubscriberIdentityOverride: Bool?
    public let mlbSerialNumber: String?
    public let mobileEquipmentIdentifier: String?
    public let mobileSubscriberCountryCode: String?
    public let mobileSubscriberNetworkCode: String?
    public let modelNumber: String?
    public let nonVolatileRam: NonVolatileRam?
    public let priVersionMajor: Int?
    public let priVersionMinor: Int?
    public let priVersionReleaseNo: Int?
    public let pairRecordProtectionClass: Int?
    public let partitionType: String
    public let passwordProtected: Bool?
    public let phoneNumber: String?
    public let pkHash: Data?
    public let productName: String
    public let productType: String
    public let productVersion: String
    public let productionSoc: Bool
    public let protocolVersion: String
    public let proximitySensorCalibration: Data?
    public let regionInfo: String?
    public let releaseType: String?
    public let sim1IsEmbedded: Bool?
    public let sim2IsEmbedded: Bool?
    public let simgid1: Data?
    public let simgid2: Data?
    public let simStatus: String?
    public let simTrayStatus: String?
    public let serialNumber: String?
    public let softwareBehavior: Data?
    public let softwareBundleVersion: String?
    public let supportedDeviceFamilies: [Int]
    public let telephonyCapability: Bool
    public let timeIntervalSince1970: Double?
    public let timeZone: String?
    public let timeZoneOffsetFromUtc: Int?
    public let trustedHostAttached: Bool?
    public let uniqueChipId: Int
    public let uniqueDeviceId: String
    public let useRaptorCerts: Bool?
    public let uses24HourClock: Bool?
    public let wiFiAddress: String
    public let wirelessBoardSerialNumber: String?
    public let kCtPostponementInfoPriVersion: String?
    public let kCtPostponementInfoServiceProvisioningState: Bool?
    public let kCtPostponementStatus: String?

    enum CodingKeys: String, CodingKey {
        case activationState = "ActivationState"
        case activationStateAcknowledged = "ActivationStateAcknowledged"
        case basebandActivationTicketVersion = "BasebandActivationTicketVersion"
        case basebandCertId = "BasebandCertId"
        case basebandChipId = "BasebandChipID"
        case basebandKeyHashInformation = "BasebandKeyHashInformation"
        case basebandMasterKeyHash = "BasebandMasterKeyHash"
        case basebandRegionSku = "BasebandRegionSKU"
        case basebandSerialNumber = "BasebandSerialNumber"
        case basebandStatus = "BasebandStatus"
        case basebandVersion = "BasebandVersion"
        case bluetoothAddress = "BluetoothAddress"
        case boardId = "BoardId"
        case brickState = "BrickState"
        case buildVersion = "BuildVersion"
        case cpuArchitecture = "CPUArchitecture"
        case carrierBundleInfoArray = "CarrierBundleInfoArray"
        case certId = "CertID"
        case chipId = "ChipID"
        case chipSerialNo = "ChipSerialNo"
        case deviceClass = "DeviceClass"
        case deviceColor = "DeviceColor"
        case deviceName = "DeviceName"
        case dieId = "DieID"
        case ethernetAddress = "EthernetAddress"
        case firmwareVersion = "FirmwareVersion"
        case fusingStatus = "FusingStatus"
        case gid1 = "GID1"
        case gid2 = "GID2"
        case hardwareModel = "HardwareModel"
        case hardwarePlatform = "HardwarePlatform"
        case hasSiDp = "HasSiDP"
        case hostAttached = "HostAttached"
        case integratedCircuitCardIdentity = "IntegratedCircuitCardIdentity"
        case integratedCircuitCardIdentity2 = "IntegratedCircuitCardIdentity2"
        case internationalMobileEquipmentIdentity = "InternationalMobileEquipmentIdentity"
        case internationalMobileEquipmentIdentity2 = "InternationalMobileEquipmentIdentity2"
        case internationalMobileSubscriberIdentity = "InternationalMobileSubscriberIdentity"
        case internationalMobileSubscriberIdentity2 = "InternationalMobileSubscriberIdentity2"
        case internationalMobileSubscriberIdentityOverride = "InternationalMobileSubscriberIdentityOverride"
        case mlbSerialNumber = "MLBSerialNumber"
        case mobileEquipmentIdentifier = "MobileEquipmentIdentifier"
        case mobileSubscriberCountryCode = "MobileSubscriberCountryCode"
        case mobileSubscriberNetworkCode = "MobileSubscriberNetworkCode"
        case modelNumber = "ModelNumber"
        case nonVolatileRam = "NonVolatileRAM"
        case priVersionMajor = "PRIVersion_Major"
        case priVersionMinor = "PRIVersion_Minor"
        case priVersionReleaseNo = "PRIVersion_ReleaseNo"
        case pairRecordProtectionClass = "PairRecordProtectionClass"
        case partitionType = "PartitionType"
        case passwordProtected = "PasswordProtected"
        case phoneNumber = "PhoneNumber"
        case pkHash = "PkHash"
        case productName = "ProductName"
        case productType = "ProductType"
        case productVersion = "ProductVersion"
        case productionSoc = "ProductionSOC"
        case protocolVersion = "ProtocolVersion"
        case proximitySensorCalibration = "ProximitySensorCalibration"
        case regionInfo = "RegionInfo"
        case releaseType = "ReleaseType"
        case sim1IsEmbedded = "SIM1IsEmbedded"
        case sim2IsEmbedded = "SIM2IsEmbedded"
        case simgid1 = "SIMGID1"
        case simgid2 = "SIMGID2"
        case simStatus = "SIMStatus"
        case simTrayStatus = "SIMTrayStatus"
        case serialNumber = "SerialNumber"
        case softwareBehavior = "SoftwareBehavior"
        case softwareBundleVersion = "SoftwareBundleVersion"
        case supportedDeviceFamilies = "SupportedDeviceFamilies"
        case telephonyCapability = "TelephonyCapability"
        case timeIntervalSince1970 = "TimeIntervalSince1970"
        case timeZone = "TimeZone"
        case timeZoneOffsetFromUtc = "TimeZoneOffsetFromUTC"
        case trustedHostAttached = "TrustedHostAttached"
        case uniqueChipId = "UniqueChipID"
        case uniqueDeviceId = "UniqueDeviceID"
        case useRaptorCerts = "UseRaptorCerts"
        case uses24HourClock = "Uses24HourClock"
        case wiFiAddress = "WiFiAddress"
        case wirelessBoardSerialNumber = "WirelessBoardSerialNumber"
        case kCtPostponementInfoPriVersion = "kCTPostponementInfoPRIVersion"
        case kCtPostponementInfoServiceProvisioningState = "kCTPostponementInfoServiceProvisioningState"
        case kCtPostponementStatus = "kCTPostponementStatus"
    }
}
