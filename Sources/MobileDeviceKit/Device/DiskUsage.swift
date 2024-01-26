import Foundation

public struct DiskUsage: Codable {
    public let calculateDiskUsage: String
    public let amountDataReserved: Int64
    public let cameraUsage: Int64
    public let totalSystemAvailable: Int64
    public let amountDataAvailable: Int64
    public let amountRestoreAvailable: Int64
    public let mediaCacheUsage: Int64
    public let photoUsage: Int64
    public let calendarUsage: Int64
    public let totalDataCapacity: Int64
    public let totalDataAvailable: Int64
    public let totalSystemCapacity: Int64
    public let webAppCacheUsage: Int64
    public let notesUsage: Int64
    public let totalDiskCapacity: Int64
    public let nandInfo: Data
    public let voicemailUsage: Int64

    enum CodingKeys: String, CodingKey {
        case calculateDiskUsage = "CalculateDiskUsage"
        case amountDataReserved = "AmountDataReserved"
        case cameraUsage = "CameraUsage"
        case totalSystemAvailable = "TotalSystemAvailable"
        case amountDataAvailable = "AmountDataAvailable"
        case amountRestoreAvailable = "AmountRestoreAvailable"
        case mediaCacheUsage = "MediaCacheUsage"
        case photoUsage = "PhotoUsage"
        case calendarUsage = "CalendarUsage"
        case totalDataCapacity = "TotalDataCapacity"
        case totalDataAvailable = "TotalDataAvailable"
        case totalSystemCapacity = "TotalSystemCapacity"
        case webAppCacheUsage = "WebAppCacheUsage"
        case notesUsage = "NotesUsage"
        case totalDiskCapacity = "TotalDiskCapacity"
        case nandInfo = "NANDInfo"
        case voicemailUsage = "VoicemailUsage"
    }
}
