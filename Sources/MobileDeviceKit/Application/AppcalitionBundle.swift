import Foundation

public enum ApplicationType: String, Codable {
    case `internal` = "Internal"
    case system = "System"
    case user = "User"
    case any = "Any"
}

public struct BundlePrimaryIcon: Codable {
    public let bundleIconFiles: [String]
    public let bundleIconName: String?
    public let uiPrerenderedIcon: Bool? = false // A Boolean value indicating whether the app’s icon already contains a shine effect.

    enum CodingKeys: String, CodingKey {
        case bundleIconFiles = "CFBundleIconFiles"
        case bundleIconName = "CFBundleIconName"
        case uiPrerenderedIcon = "UIPrerenderedIcon"
    }
}

public struct BundleIcons: Codable {
    public let bundlePrimaryIcon: BundlePrimaryIcon

    enum CodingKeys: String, CodingKey {
        case bundlePrimaryIcon = "CFBundlePrimaryIcon"
    }
}

public struct StoreMetadata: Codable {
    public struct Rating: Codable {
        public let label: String
        public let rank: Int

        enum CodingKeys: String, CodingKey {
            case label
            case rank
        }
    }

    public struct AccountInfo: Codable {
        public let appleID: String
        public let dsPersonID: Int
        public let purchaserID: Int

        enum CodingKeys: String, CodingKey {
            case appleID = "AppleID"
            case dsPersonID = "DSPersonID"
            case purchaserID = "PurchaserID"
        }
    }

    public struct DownloadInfo: Codable {
        public let accountInfo: AccountInfo
        public let purchaseDate: String

        enum CodingKeys: String, CodingKey {
            case accountInfo
            case purchaseDate
        }
    }

    public let bundleShortVersionString: String
    public let bundleVersion: String
    public let itemName: String
    public let genre: String
    public let rating: Rating?
    public let sourceApp: String?
    public let artistName: String
    public let launchProhibited: Bool?
    public let downloadInfo: DownloadInfo?
    public let softwareVersionExternalIdentifier: Int

    enum CodingKeys: String, CodingKey {
        case bundleShortVersionString
        case bundleVersion
        case itemName
        case genre
        case rating
        case sourceApp
        case artistName
        case launchProhibited
        case downloadInfo = "com.apple.iTunesStore.downloadInfo"
        case softwareVersionExternalIdentifier
    }
}

public struct AppcalitionBundle: Codable {
    public let applicationDsid: Int?
    public let applicationType: ApplicationType
    public let buildMachineOsBuild: String?
    public let bundleDevelopmentRegion: String?
    public let bundleDisplayName: String?
    public let bundleExecutable: String
    public let bundleIcons: BundleIcons?
    public let bundleIconFiles: [String]?
    public let bundleIdentifier: String
    public let bundleLocalizations: [String]?
    public let bundleName: String
    public let bundleShortVersionString: String?
    public let bundleVersion: String
    public let container: String
    public let minimumOsVersion: String
    public let fileSharingEnabled: Bool?
    public let signerIdentity: String
    public let signatureExpirationDate: Date?
    public let iTunesMetadata: Data?

    public var storeMetadata: StoreMetadata? {
        if let iTunesMetadata = iTunesMetadata {
            return try? StoreMetadata(data: iTunesMetadata, format: .plist)
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case applicationDsid = "ApplicationDSID"
        case applicationType = "ApplicationType"
        case buildMachineOsBuild = "BuildMachineOSBuild"
        case bundleDevelopmentRegion = "CFBundleDevelopmentRegion"
        case bundleDisplayName = "CFBundleDisplayName"
        case bundleExecutable = "CFBundleExecutable"
        case bundleIcons = "CFBundleIcons"
        case bundleIconFiles = "CFBundleIconFiles"
        case bundleIdentifier = "CFBundleIdentifier"
        case bundleLocalizations = "CFBundleLocalizations"
        case bundleName = "CFBundleName"
        case bundleShortVersionString = "CFBundleShortVersionString"
        case bundleVersion = "CFBundleVersion"
        case container = "Container"
        case minimumOsVersion = "MinimumOSVersion"
        case fileSharingEnabled = "UIFileSharingEnabled"
        case signerIdentity = "SignerIdentity"
        case signatureExpirationDate = "SignatureExpirationDate"
        case iTunesMetadata
    }
}
